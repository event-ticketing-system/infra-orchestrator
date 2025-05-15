#!/bin/bash

IMAGE_PATH="./event-img.jpg"
UPLOAD_URL="http://localhost:8004/api/catalog/upload-image/"
EVENT_URL="http://localhost:8004/api/catalog/events"

for i in {1..5}
do
  echo "Uploading image for event $i..."

  # Upload the image
  RESPONSE=$(curl -s -X POST "$UPLOAD_URL" \
    -H 'accept: application/json' \
    -H 'Content-Type: multipart/form-data' \
    -F "file=@${IMAGE_PATH};type=image/jpeg")

  IMAGE_URL=$(echo "$RESPONSE" | jq -r '.url')

  # Generate unique ID and name
  UUID=$(uuidgen | cut -c1-8)
  NOW=$(date -Iseconds)

  echo "Creating event with ID=Test_${UUID}, Image URL=${IMAGE_URL}"

  # Create event
  curl -s -X POST "$EVENT_URL" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "{
      \"id\": \"Event_${UUID}\",
      \"name\": \"Event_${UUID}\",
      \"description\": \"Have a blast!\",
      \"location\": \"Bangalore\",
      \"available_tickets\": 20,
      \"price\": 10,
      \"image\": \"${IMAGE_URL}\",
      \"created_at\": \"${NOW}\",
      \"updated_at\": \"${NOW}\"
    }" | jq
done
