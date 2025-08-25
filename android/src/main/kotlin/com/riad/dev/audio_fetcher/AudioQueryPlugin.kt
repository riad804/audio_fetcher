package com.riad.dev.audio_fetcher

import android.content.Context
import android.content.ContentResolver
import android.database.Cursor
import android.provider.MediaStore
import android.net.Uri
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.util.Base64
import java.io.ByteArrayOutputStream

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AudioQueryPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "audio_fetcher")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getSongs" -> result.success(getSongs())
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getSongs(): List<Map<String, Any?>> {
        val songs = mutableListOf<Map<String, Any?>>()
        val resolver: ContentResolver = context.contentResolver
        val uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        val cursor: Cursor? = resolver.query(
            uri,
            arrayOf(
                MediaStore.Audio.Media._ID,
                MediaStore.Audio.Media.TITLE,
                MediaStore.Audio.Media.ARTIST,
                MediaStore.Audio.Media.DATA,
                MediaStore.Audio.Media.ALBUM_ID
            ),
            "${MediaStore.Audio.Media.IS_MUSIC}!=0",
            null,
            null
        )

        cursor?.use { it ->
            val idCol = it.getColumnIndex(MediaStore.Audio.Media._ID)
            val titleCol = it.getColumnIndex(MediaStore.Audio.Media.TITLE)
            val artistCol = it.getColumnIndex(MediaStore.Audio.Media.ARTIST)
            val dataCol = it.getColumnIndex(MediaStore.Audio.Media.DATA)
            val albumIdCol = it.getColumnIndex(MediaStore.Audio.Media.ALBUM_ID)

            while (it.moveToNext()) {
                val albumId = it.getLong(albumIdCol)
                val (image, duration) = getAudioMetadata(dataCol.toString())

                songs.add(
                    mapOf(
                        "id" to it.getLong(idCol),
                        "title" to it.getString(titleCol),
                        "artist" to it.getString(artistCol),
                        "duration" to duration,
                        "path" to it.getString(dataCol),
                        "image" to image
                    )
                )
            }
        }
        return songs
    }

    fun getAudioMetadata(filePath: String): Pair<String?, Long?> {
        val retriever = MediaMetadataRetriever()
        try {
            // Set the data source (path to the audio file)
            retriever.setDataSource(filePath)

            // Get album art as a byte array
            val albumArtBytes = retriever.embeddedPicture
            val albumArtBase64 = albumArtBytes?.let {
                Base64.encodeToString(it, Base64.DEFAULT)
            }


            // Get duration in milliseconds
            val durationString = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
            val duration = durationString?.toLongOrNull()

            return Pair(albumArtBase64, duration)
        } catch (e: Exception) {
            e.printStackTrace()
            return Pair(null, null) // Return nulls in case of an error
        } finally {
            // Release the retriever to free resources
            retriever.release()
        }
    }
}