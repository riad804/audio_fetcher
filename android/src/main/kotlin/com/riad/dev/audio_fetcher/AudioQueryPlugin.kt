package com.riad.dev.audio_fetcher

import android.content.Context
import android.content.ContentResolver
import android.database.Cursor
import android.provider.MediaStore
import android.net.Uri
import android.graphics.BitmapFactory
import android.graphics.Bitmap
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
                val image = getAlbumArt(albumId)

                songs.add(
                    mapOf(
                        "id" to it.getLong(idCol),
                        "title" to it.getString(titleCol),
                        "artist" to it.getString(artistCol),
                        "path" to it.getString(dataCol),
                        "image" to image // base64 thumbnail
                    )
                )
            }
        }
        return songs
    }

    private fun getAlbumArt(albumId: Long): String? {
        val albumUri = Uri.parse("content://media/external/audio/albumart")
        val uri = Uri.withAppendedPath(albumUri, albumId.toString())
        return try {
            val input = context.contentResolver.openInputStream(uri)
            val bitmap = BitmapFactory.decodeStream(input)
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 60, stream)
            android.util.Base64.encodeToString(stream.toByteArray(), android.util.Base64.DEFAULT)
        } catch (e: Exception) {
            null
        }
    }
}