gcloud functions deploy deleteFirestoreByUserDeletion \
    --no-gen2 \
    --entry-point delete_firestore_by_user_deletion \
    --trigger-event providers/firebase.auth/eventTypes/user.delete \
    --region asia-northeast1 \
    --source .\
    --runtime python312

