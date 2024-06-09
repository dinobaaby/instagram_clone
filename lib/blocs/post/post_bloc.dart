import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/post.dart';
import 'post_event.dart';
import 'post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final FirestoreService _firestoreService;

  PostBloc(this._firestoreService) : super(PostInitial()) {
    on<AddPostEvent>((event, emit) async {
      try {
        await _firestoreService.addPost(event.post);
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        _firestoreService.getPosts().listen((posts) {
          emit(PostLoaded(posts));
        });
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost(Post post) {
    return _db.collection('posts').doc(post.postId).set(post.toJson());
  }

  Stream<List<Post>> getPosts() {
    return _db.collection('posts').orderBy('timestamp', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Post.fronSnap(doc.data() as DocumentSnapshot<Object?>)).toList(),
    );
  }
}