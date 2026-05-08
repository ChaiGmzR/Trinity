import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    _controller?.dispose();
    super.dispose();
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
    await old?.dispose();

    final controller = canUseOnline
        ? VideoPlayerController.networkUrl(Uri.parse(widget.networkVideoUrl))
        : VideoPlayerController.asset(widget.assetVideo);

    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (error) {
      await controller.dispose();
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
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (initialized)
                  VideoPlayer(controller!)
                else
                  Image.asset(widget.posterAsset, fit: BoxFit.cover),
                if (_loading)
                  Container(
                    color: Colors.black45,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                if (_error != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.black.withValues(alpha: 0.72),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: initialized && controller!.value.isPlaying
                  ? 'Pausar'
                  : 'Reproducir',
              onPressed: initialized
                  ? () {
                      setState(() {
                        controller!.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    }
                  : null,
              icon: Icon(
                initialized && controller!.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Offline'),
              selected: !_online,
              onSelected: (_) => _load(online: false),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Internet'),
              selected: _online,
              onSelected: widget.networkVideoUrl.isEmpty
                  ? null
                  : (_) => _load(online: true),
            ),
            const Spacer(),
            if (initialized)
              Text(
                _online ? 'Streaming' : 'Asset local',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
