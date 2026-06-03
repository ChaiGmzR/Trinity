import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_colors.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  const ExerciseVideoPlayer({
    super.key,
    required this.assetVideo,
    required this.networkVideoUrl,
    required this.posterAsset,
  });

  final String assetVideo;
  final String networkVideoUrl;
  final String posterAsset;

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _online = false;
  bool _loading = true;
  String? _error;

  // Nuevas variables para control avanzado
  bool _showControls = true;
  Timer? _controlsTimer;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _load(online: false);
  }

  @override
  void didUpdateWidget(covariant ExerciseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetVideo != widget.assetVideo ||
        oldWidget.networkVideoUrl != widget.networkVideoUrl) {
      _online = false;
      _load(online: false);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoControllerUpdate);
    _controller?.dispose();
    _controlsTimer?.cancel();
    super.dispose();
  }

  void _onVideoControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  Future<void> _load({required bool online}) async {
    final canUseOnline = online && widget.networkVideoUrl.isNotEmpty;
    setState(() {
      _loading = true;
      _error = null;
      _online = canUseOnline;
    });

    final old = _controller;
    _controller = null;
    if (old != null) {
      old.removeListener(_onVideoControllerUpdate);
      await old.dispose();
    }

    final controller = canUseOnline
        ? VideoPlayerController.networkUrl(Uri.parse(widget.networkVideoUrl))
        : VideoPlayerController.asset(widget.assetVideo);

    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      await controller.setVolume(_muted ? 0.0 : 1.0);
      controller.addListener(_onVideoControllerUpdate);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
        _showControls = true;
      });
      _resetControlsTimer();
    } catch (error) {
      if (old != null) {
        old.addListener(_onVideoControllerUpdate);
        _controller = old;
      }
      if (!mounted) {
        return;
      }
      if (canUseOnline) {
        setState(() {
          _error = 'No se pudo cargar el video online. Usando demo offline.';
        });
        await _load(online: false);
        return;
      }
      setState(() {
        _loading = false;
        _error = 'No se pudo reproducir el video local.';
      });
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _controller;
    final initialized = controller?.value.isInitialized ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: initialized ? controller!.value.aspectRatio : 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (initialized)
                    GestureDetector(
                      onTap: _toggleControlsVisibility,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(controller!),
                          // Capa oscura animada
                          AnimatedOpacity(
                            opacity: _showControls ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: !_showControls,
                              child: Container(color: Colors.black45),
                            ),
                          ),
                          // Controles overlay animados
                          AnimatedOpacity(
                            opacity: _showControls ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: !_showControls,
                              child: _buildControlsOverlay(controller, theme),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Image.asset(widget.posterAsset, fit: BoxFit.cover),
                  if (_loading)
                    const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
                  if (_error != null && !_loading)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black87,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _error!,
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Fila de origen (Chips e Info)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Offline'),
                selected: !_online,
                onSelected: (_) => _load(online: false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Internet HD'),
                selected: _online,
                onSelected: widget.networkVideoUrl.isEmpty
                    ? null
                    : (_) => _load(online: true),
              ),
              const Spacer(),
              if (initialized)
                Text(
                  _online ? 'Streaming HD' : 'Local (Sin conexión)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _online ? AppColors.cyan : AppColors.textMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlsOverlay(VideoPlayerController controller, ThemeData theme) {
    final position = controller.value.position;
    final duration = controller.value.duration;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Fila superior (Mute y Status)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
                icon: Icon(
                  _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _muted = !_muted;
                    controller.setVolume(_muted ? 0.0 : 1.0);
                  });
                  _resetControlsTimer();
                },
              ),
            ],
          ),
        ),

        // Botones centrales (Retroceder 10s, Play/Pause, Adelantar 10s)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 36,
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
              icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
              onPressed: () {
                final newPos = position - const Duration(seconds: 10);
                controller.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
                _resetControlsTimer();
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 52,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
              ),
              icon: Icon(
                controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying ? controller.pause() : controller.play();
                });
                _resetControlsTimer();
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 36,
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
              icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
              onPressed: () {
                final newPos = position + const Duration(seconds: 10);
                controller.seekTo(newPos > duration ? duration : newPos);
                _resetControlsTimer();
              },
            ),
          ],
        ),

        // Barra inferior (Tiempo y Slider de reproducción)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Text(
                '${_formatDuration(position)} / ${_formatDuration(duration)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    activeTrackColor: AppColors.orange,
                    inactiveTrackColor: Colors.white30,
                    thumbColor: AppColors.orange,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayColor: AppColors.orange.withValues(alpha: 0.2),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble().clamp(
                          0.0,
                          duration.inMilliseconds.toDouble(),
                        ),
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble() > 0.0
                        ? duration.inMilliseconds.toDouble()
                        : 1.0,
                    onChanged: (val) {
                      controller.seekTo(Duration(milliseconds: val.toInt()));
                      _resetControlsTimer();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
