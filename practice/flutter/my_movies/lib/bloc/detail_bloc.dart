import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../model/trailer_model.dart';
import '../resources/repository.dart';

class DetailBloc {
    final _repository = Repository();
    final _movieId = PublishSubject<int>();
    final _trailers = BehaviorSubject<Future<TrailerModel>>();

    Function(int) get fetchTrailersById => _movieId.sink.add;
    Observable<Future<TrailerModel>> get movieTrailers => _trailers.stream;

    DetailBloc() {
        _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
    }

    dispose() async {
        _movieId.close();
        await _trailers.drain();
        _trailers.close();
    }

    _itemTransformer() {
        return ScanStreamTransformer(
                (Future<TrailerModel> trailer, int id, int index) {
                print(index);
                trailer = _repository.fetchTrailers(id);
                return trailer;
            },
        );
    }
}