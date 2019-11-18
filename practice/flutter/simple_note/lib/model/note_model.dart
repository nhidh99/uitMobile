class NoteModel {
    String id;
    String user;
    String title;
    String content;

    NoteModel(this.id, this.user, this.title, this.content);

    // Static constructor: When data is fetched from Firebase,
    // it is in JSON format => convert to NoteModel f{ormat
    NoteModel.fromMap(Map snapshot, String id) {
        this.id = id ?? '';
        this.user = snapshot['user'];
        this.title = snapshot['title'];
        this.content = snapshot['content'];
    }

    toJson() {
        return {
            "user": user,
            "title": title,
            "content": content
        };
    }
}