import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  Duration position = const Duration();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    _controller.addListener(() {
      if (_controller.value.position != position) {
        setState(() {
          position = _controller.value.position;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortait = orientation == Orientation.portrait;
          return isPortait
              ? SafeArea(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      fit: isPortait ? StackFit.loose : StackFit.expand,
                      children: [
                        Center(
                          child: VideoPlayer(_controller),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, left: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "${format(position)} / ${format(_controller.value.duration)}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onDoubleTap: () {
                                _controller.seekTo(
                                    position - const Duration(seconds: 1));
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onDoubleTap: () {
                                _controller.seekTo(
                                    position + const Duration(seconds: 1));
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            )),
                          ],
                        ),
                        if (!isLoading)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            ),
                          ),
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        isPortait
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.landscapeRight]);
                                  },
                                  child: const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.portraitUp]);
                                    });
                                  },
                                  child: const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.fullscreen_exit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ProgressBar(
                              progress: _controller.value.position,
                              total: _controller.value.duration,
                              progressBarColor: Colors.white,
                              barHeight: 1,
                              baseBarColor: Colors.grey,
                              thumbRadius: 5,
                              timeLabelLocation: TimeLabelLocation.none,
                              thumbColor: Colors.white,
                              onSeek: (duration) {
                                setState(() {
                                  _controller.seekTo(duration);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  fit: isPortait ? StackFit.loose : StackFit.expand,
                  children: [
                    Center(
                      child: VideoPlayer(_controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${format(position)}/${format(_controller.value.duration)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onDoubleTap: () {
                            _controller
                                .seekTo(position - const Duration(seconds: 1));
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onDoubleTap: () {
                            _controller
                                .seekTo(position + const Duration(seconds: 1));
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                      ],
                    ),
                    if (!isLoading)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    isPortait
                        ? Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30, left: 20),
                            child: GestureDetector(
                              onTap: () {
                                AutoOrientation.landscapeAutoMode(
                                    forceSensor: true);
                              },
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                AutoOrientation.portraitAutoMode(
                                    forceSensor: true);
                              },
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.fullscreen_exit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ProgressBar(
                          progress: _controller.value.position,
                          total: _controller.value.duration,
                          progressBarColor: Colors.white,
                          barHeight: 1,
                          baseBarColor: Colors.grey,
                          thumbRadius: 5,
                          timeLabelLocation: TimeLabelLocation.none,
                          thumbColor: Colors.white,
                          onSeek: (duration) {
                            setState(() {
                              _controller.seekTo(duration);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  format(Duration d) => d.toString().substring(2, 7);
}
