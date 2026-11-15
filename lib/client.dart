import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'packet_buffer.dart';

class Entity {
  final (double, double) position;
  final double angle;
  final Color color;

  Entity(this.position, this.angle, this.color);
}

class Frog extends Entity {
  final double tongueWidth;

  Frog(super.position, super.angle, super.color, this.tongueWidth);
}

class Bug extends Entity {
  Bug(super.position, super.angle, super.color);
}

class PondClient {
  final PacketBuffer _buffer = PacketBuffer();
  final Queue<(List<Frog>, List<Bug>)> frames = Queue();
  Completer<void> nextFrame = Completer();

  Future<(List<Frog>, List<Bug>)> getEntities() async {
    if (frames.isEmpty) {
      await nextFrame.future;
    }
    return frames.removeFirst();
  }

  PondClient(InternetAddress serverAddress, int serverPort) {
    Socket.connect(serverAddress, serverPort).then((value) {
      value.add([0]); // this is a graphical client, not a frog
      value.listen((event) {
        _buffer.add(event);
        while (_buffer.available >= 2) {
          Uint8List entityCounts = _buffer.readUint8List(2);
          if (_buffer.available >= entityCounts[0] * 3 * 8 + entityCounts[1] * 2 * 8) {
            frames;
          } else {
            _buffer.rewind();
            break;
          }
        }
      });
    });
  }
}
