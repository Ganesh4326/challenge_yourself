import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/AuthService.dart';
import '../../core/blocs/base_cubit.dart';
import '../../models/user.dart';
import '../../services/fire_store.dart';

part 'users_friends_screen_state.dart';

part 'users_friends_screen_cubit.freezed.dart';

class UsersFriendsScreenCubit extends BaseCubit<UsersFriendsScreenState> {
  UsersFriendsScreenCubit({required super.context})
      : super(
            initialState: UsersFriendsScreenState.initial(
                friendListIds: [], friendListUsers: [])) {
    getUserId();
  }

  getUserId() async {
    String? userId = await AuthService.getUserId();
    emit(state.copyWith(userId: userId));
    getUserFriendList();
  }

  getUserFriendList() async {
    emitState(state.copyWith(
        friendListIds:
            await FireStoreService().getUserFriendList(state.userId!)));
    List<Users> users = [];
    for (int i = 0; i < state.friendListIds!.length; i++) {
      Users? user =
          await FireStoreService().getUserData(state.friendListIds![i]);
      users.add(user);
    }
    emitState(state.copyWith(friendListUsers: users));
  }
}
