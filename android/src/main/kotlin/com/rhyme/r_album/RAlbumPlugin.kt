package com.rhyme.r_album

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.Intent.ACTION_MEDIA_SCANNER_SCAN_FILE
import android.net.Uri
import android.os.Environment
import android.os.Handler
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File
import java.io.FileInputStream
import java.lang.Exception
import kotlin.concurrent.thread

/** RAlbumPlugin */
const val methodName: String = "com.rhyme_lph/r_album"
var context: Context? = null

public class RAlbumPlugin : FlutterPlugin, MethodCallHandler {
    private val handler: Handler = Handler()
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), methodName)
        channel.setMethodCallHandler(RAlbumPlugin())

    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            context = registrar.activity()

            val channel = MethodChannel(registrar.messenger(), methodName)
            channel.setMethodCallHandler(RAlbumPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "createAlbum" -> createAlbum(call, result)
            "saveAlbum" -> saveAlbum(call, result)
            else -> result.notImplemented()
        }
    }

    private fun saveAlbum(call: MethodCall, result: Result) {

        val albumName = call.argument<String>("albumName")
        val filePaths = call.argument<List<String>>("filePaths")
        if (albumName == null) {
            result.error("100", "albumName is not null", null)
            return
        }
        if (filePaths == null) {
            result.error("101", "filePaths is not null", null)
            return
        }
        thread {
            val rootFile = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), albumName)
            if (!rootFile.exists()) {
                rootFile.mkdirs()
            }

            val resultPaths = mutableListOf<String>()

            try {
                for (path in filePaths) {
                    val fileName: String = if (path.lastIndexOf('.') == -1) {
                        "${System.currentTimeMillis()}"
                    } else {
                        val suffix: String = path.substring(path.lastIndexOf(".") + 1)
                        "${System.currentTimeMillis()}.$suffix"
                    }
                    val itemFile = File(rootFile, fileName)
                    if (!itemFile.exists()) itemFile.createNewFile()
                    val outPut = itemFile.outputStream()
                    val inPut = FileInputStream(path)
                    val buf = ByteArray(1024)
                    var len = 0
                    while (true) {
                        len = inPut.read(buf)
                        if (len == -1) break
                        outPut.write(buf, 0, len)
                    }
                    outPut.flush()
                    outPut.close()

                    inPut.close()
                    resultPaths.add(itemFile.absolutePath)
                    handler.post {
                        context!!.sendBroadcast(Intent(ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(itemFile)))
                    }
                }
                handler.post {
                    result.success(true)
                }
            } catch (e: Exception) {
                handler.post {
                    result.success(false)
                }
            }
        }
    }

    private fun createAlbum(call: MethodCall, result: Result) {
        val albumName = call.argument<String>("albumName")
        if (albumName == null) {
            result.success(false)
            return
        }
        thread {
            val rootFile = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), albumName)
            if (!rootFile.exists()) {
                rootFile.mkdirs()
            }
            handler.post {
                result.success(true)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = null

    }
}
