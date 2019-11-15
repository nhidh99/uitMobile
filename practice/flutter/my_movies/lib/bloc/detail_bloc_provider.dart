import 'package:flutter/material.dart';
import 'detail_bloc.dart';
export 'detail_bloc.dart';

class DetailBlocProvider extends InheritedWidget {
    final DetailBloc bloc;

    DetailBlocProvider({Key key, Widget child})
        : bloc = DetailBloc(),
            super(key: key, child: child);

    @override
    bool updateShouldNotify(_) {
        return true;
    }

    static DetailBloc of(BuildContext context) {
        return (context.inheritFromWidgetOfExactType(DetailBlocProvider)
        as DetailBlocProvider)
            .bloc;
    }
}