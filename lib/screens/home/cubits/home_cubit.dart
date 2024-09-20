import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeCubit() : super(CategoriesInitial());

  final List<Map<String, dynamic>> items = [
    {
      "name": "Professional Skills",
      "image": "https://img.freepik.com/free-vector/designer-collection-concept_23-2148516847.jpg",
      "code": "",
      "icon": "",
      "id": "db14b560-8158-4703-b50a-a4d657960d70",
      "language": "/langauge/AsWo8s12VLmWgFoYjsNY",
      "order": "",
      "predecessor": 0,
      "status": "",
      "text": ""
    },
    {
      "name": "Personal Points",
      "image": "https://img.freepik.com/free-vector/storyboard-process-illustration_23-2148679316.jpg",
      "code": "",
      "icon": "",
      "id": "0f626459-8003-4ecd-ac42-859216229556",
      "language": "/langauge/AsWo8s12VLmWgFoYjsNY",
      "order": "",
      "predecessor": 0,
      "status": "",
      "text": ""
    },
    {
      "name": "Academic Issues",
      "image": "https://img.freepik.com/free-vector/flat-design-essay-illustration_23-2150354384.jpg",
      "code": "",
      "icon": "",
      "id": "47b29e84-5744-4e73-9131-e8396b658266",
      "language": "/langauge/AsWo8s12VLmWgFoYjsNY",
      "order": "",
      "predecessor": 0,
      "status": "",
      "text": ""
    },
    {
      "name": "Marriage Help",
      "image": "https://img.freepik.com/free-vector/flat-design-asian-couple-illustration_23-2149994589.jpg",
      "code": "",
      "icon": "",
      "id": "a5294178-322a-4453-995b-0ee7914a5468",
      "language": "/langauge/AsWo8s12VLmWgFoYjsNY",
      "order": "",
      "predecessor": 0,
      "status": "",
      "text": ""
    },
    {
      "name": "Career Guidance",
      "image": "https://img.freepik.com/free-vector/workflow-infographic_24908-59271.jpg",
      "code": "",
      "icon": "",
      "id": "994f4a3d-3dcd-4d96-8084-98a51765c140",
      "language": "/langauge/AsWo8s12VLmWgFoYjsNY",
      "order": "",
      "predecessor": 0,
      "status": "",
      "text": ""
    }
  ];


  Future<void> loadCategories() async {
    try {
      emit(CategoriesLoading());
      final QuerySnapshot snapshot = await _firestore.collection('categories').get();
      final categories = snapshot.docs.map((doc) => Categories.fromFirestore(doc)).toList();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}