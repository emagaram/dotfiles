#!/bin/bash

fas_file_name="2Fas.2fas"
fas_file_path="$HOME/Downloads/$fas_file_name"

if [ -e "$fas_file_path" ]; then
    echo "File '$fas_file_name' found in ~/Downloads."
else
    echo "Error: File '$fas_file_name' not found in ~/Downloads."
    exit 1
fi

START=$(pwd)
SCRATCH="$HOME/Downloads/ScratchWork"
GDO_PASS=$(security find-generic-password -w -a "Ezra" -s "GDOPassword")

terminate(){
    rm -rf $SCRATCH
    cd $START
    exit 1
}

rm -rf $SCRATCH 2>/dev/null
mkdir $SCRATCH
cd $SCRATCH
mkdir Data
cd Data
BW_STATUS=$(bw status | jq .status)

echo "Signing in to bitwarden..."
if [ $BW_STATUS = '"locked"' ]; then
   bw export --format json
elif [ $BW_STATUS = '"unauthenticated"' ]; then
    bw login
    bw export --format json
else 
    echo $BW_STATUS
    echo "Unexpected BW status"
    terminate
fi
if [ $? -ne 0 ]; then
    echo "Failed to login to Bitwarden."
    terminate
fi
bw lock
mv $fas_file_path ./
tar -cvf ../Data.tar .

#For later
cp ../Data.tar ./

date +"%A, %B %d, %Y %H:%M:%S" > "./BackupDate.txt"
gpg --batch --passphrase "$GDO_PASS" -c Data.tar
shopt -s extglob
rm -rf !(Data.tar.gpg|BackupDate.txt)
# Inside of scratchwork is an unencrypted complete Folder

# exit
# Google
GD_CLIENT_ID=$(security find-generic-password -w -a "Ezra" -s "GoogleClientID")
GD_CLIENT_SECRET=$(security find-generic-password -w -a "Ezra" -s "GoogleClientSecret")
GD_REFRESH_TOKEN=$(security find-generic-password -w -a "Ezra" -s "GoogleRefreshToken")
GD_FOLDER_ID=$(security find-generic-password -w -a "Ezra" -s "GoogleDriveBackupFolderID")

# Dropbox
DB_APP_KEY=$(security find-generic-password -w -a "Ezra" -s "DropboxAppKey")
DB_APP_SECRET=$(security find-generic-password -w -a "Ezra" -s "DropboxAppSecret")
DB_AUTHORIZATION_URL="https://www.dropbox.com/oauth2/authorize?client_id=$DB_APP_KEY&response_type=code&token_access_type=offline"
DB_REFRESH_TOKEN=$(security find-generic-password -w -a "Ezra" -s "DropboxRefreshToken" 2>/dev/null)

DB2_APP_KEY=$(security find-generic-password -w -a "Ezra" -s "DropboxAppKey2")
DB2_APP_SECRET=$(security find-generic-password -w -a "Ezra" -s "DropboxAppSecret2")
DB2_AUTHORIZATION_URL="https://www.dropbox.com/oauth2/authorize?client_id=$DB2_APP_KEY&response_type=code&token_access_type=offline"
DB2_REFRESH_TOKEN=$(security find-generic-password -w -a "Ezra" -s "DropboxRefreshToken2" 2>/dev/null)
DB2_PASS=$(security find-generic-password -w -a "Ezra" -s "Dropbox2Password")

LOCAL_DIRECTORY="$SCRATCH/Data"
DESTINATION_DIR="/DataRestoreCloudProviders/Data"

# OneDrive configuration
OD_CLIENT_ID=$(security find-generic-password -w -a "Ezra" -s "OneDriveClientID")
OD_CLIENT_SECRET=$(security find-generic-password -w -a "Ezra" -s "OneDriveClientSecret")
OD_REDIRECT_URI="http://localhost"
OD_TENANT_ID=$(security find-generic-password -w -a "Ezra" -s "OneDriveTenantID")
OD_SCOPE="offline_access files.readwrite.all"

get_secure_token() {
    local account="$1"
    local service="$2"
    security find-generic-password -w -a "$account" -s "$service" 2>/dev/null
}
save_to_keychain() {
    local account="$1"
    local service="$2"
    local token="$3"
    if security find-generic-password -a "$account" -s "$service" >/dev/null 2>&1; then
        security add-generic-password -a "$account" -s "$service" -w "$token" -U
    else
        security add-generic-password -a "$account" -s "$service" -w "$token"
    fi
}

generate_od_auth_url() {
    echo "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=$OD_CLIENT_ID&scope=$OD_SCOPE&response_type=code&redirect_uri=$OD_REDIRECT_URI"
}

get_onedrive_access_token() {
    local AUTH_CODE

    OD_REFRESH_TOKEN=$(security find-generic-password -w -a "Ezra" -s "OneDriveRefreshToken")

    if [ -n "$OD_REFRESH_TOKEN" ]; then
        echo "Refreshing OneDrive access token..."
        TOKEN_RESPONSE=$(curl -s --request POST \
            --url "https://login.microsoftonline.com/common/oauth2/v2.0/token" \
            --header "Content-Type: application/x-www-form-urlencoded" \
            --data-urlencode "client_id=$OD_CLIENT_ID" \
            --data-urlencode "scope=$OD_SCOPE" \
            --data-urlencode "refresh_token=$OD_REFRESH_TOKEN" \
            --data-urlencode "grant_type=refresh_token" \
            --data-urlencode "client_secret=$OD_CLIENT_SECRET")

        if echo "$TOKEN_RESPONSE" | jq . >/dev/null; then
            OD_ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
            OD_REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token')

            if [ -n "$OD_ACCESS_TOKEN" ]; then
                save_to_keychain "Ezra" "OneDriveAccessToken" "$OD_ACCESS_TOKEN"
                save_to_keychain "Ezra" "OneDriveRefreshToken" "$OD_REFRESH_TOKEN"
                echo "OneDrive access token refreshed."
            else
                echo "Failed to obtain refreshed OneDrive access token."
                terminate
            fi
        else
            echo "Failed to parse token response when refreshing OneDrive access token."
            terminate
        fi
    else
        echo "Please visit the following URL and authorize the app, then enter your authorization code:"
        echo $(generate_od_auth_url)
        read -p "Enter the OD authorization code: " AUTH_CODE

        TOKEN_RESPONSE=$(curl -s --request POST \
            --url "https://login.microsoftonline.com/common/oauth2/v2.0/token" \
            --header "Content-Type: application/x-www-form-urlencoded" \
            --data-urlencode "client_id=$OD_CLIENT_ID" \
            --data-urlencode "scope=$OD_SCOPE" \
            --data-urlencode "code=$AUTH_CODE" \
            --data-urlencode "redirect_uri=$OD_REDIRECT_URI" \
            --data-urlencode "grant_type=authorization_code" \
            --data-urlencode "client_secret=$OD_CLIENT_SECRET")

        if echo "$TOKEN_RESPONSE" | jq .; then
            OD_ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
            OD_REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token')

            if [ -n "$OD_REFRESH_TOKEN" ]; then
                save_to_keychain "Ezra" "OneDriveRefreshToken" "$OD_REFRESH_TOKEN"
            else
                echo "Failed to obtain OneDrive access token."
                terminate
            fi
        else
            echo "Failed to parse token response."
            terminate
        fi
    fi
}


upload_to_onedrive() {
    local local_file="$1"
    local onedrive_file=$(basename "$local_file")
    local UPLOAD_URL="https://graph.microsoft.com/v1.0/me/drive/root:$DESTINATION_DIR/$onedrive_file:/content"
    response=$(curl -s -X PUT $UPLOAD_URL --header "Authorization: Bearer $OD_ACCESS_TOKEN" \
         --header "Content-Type: application/octet-stream" --data-binary @"$local_file")
    # echo "$response"

    if [ $? -eq 0 ]; then
        echo "Uploaded to OneDrive: $onedrive_file"
    else
        echo "Upload to OneDrive failed: $onedrive_file"
    fi
}

# Maybe just jq instead of grep
get_google_access_and_refresh_token() {
    GD_AUTH_URL="https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A//www.googleapis.com/auth/drive.file&access_type=offline&include_granted_scopes=true&response_type=code&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&client_id=$GD_CLIENT_ID"
    echo "Please visit this URL and authorize the app, then enter your authorization code:"
    echo "$GD_AUTH_URL"
    echo "Enter the Google authorization code: " 
    read AUTH_CODE
    TOKEN_RESPONSE=$(curl -s --request POST --data "code=$AUTH_CODE&client_id=$GD_CLIENT_ID&client_secret=$GD_CLIENT_SECRET&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" "https://oauth2.googleapis.com/token")
    if [ $? -ne 0 ]; then
        echo "curl command failed, received: $TOKEN_RESPONSE"
        terminate
    fi

    GD_ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token": "[^"]*' | grep -o '[^"]*$')
    GD_REFRESH_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"refresh_token": "[^"]*' | grep -o '[^"]*$')
    save_to_keychain "Ezra" "GoogleRefreshToken" "$GD_REFRESH_TOKEN"
}
refresh_google_access_token() {
    TOKEN_RESPONSE=$(curl -s --request POST --data "client_id=$GD_CLIENT_ID&client_secret=$GD_CLIENT_SECRET&refresh_token=$GD_REFRESH_TOKEN&grant_type=refresh_token" "https://oauth2.googleapis.com/token")
    if [ $? -ne 0 ]; then
        echo "curl command failed, received: $TOKEN_RESPONSE"
        terminate
    fi
    ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token": "[^"]*' | grep -o '[^"]*$')
}
upload_to_googledrive() {
    local local_file="$1"
    drive_file=$(basename "$local_file")

    # Note: The MIME type is set to "application/octet-stream", adjust if needed.
    response=$(curl -s -X POST https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart \
        --header "Authorization: Bearer $GD_ACCESS_TOKEN" \
        --header "Content-Type: multipart/related; boundary=foo_bar_baz" \
        --data-binary @- <<EOF
--foo_bar_baz
Content-Type: application/json; charset=UTF-8

{
  "name": "$drive_file",
  "parents": ["$GD_FOLDER_ID"]
}

--foo_bar_baz
Content-Type: application/octet-stream

$(cat "$local_file")

--foo_bar_baz--
EOF
)

    if [ $? -eq 0 ]; then
        echo "Uploaded to Google Drive: $drive_file"
    else
        echo "Upload to Google Drive failed: $drive_file, received: $response"
        terminate
    fi
}


upload_to_dropbox() {
    local local_file="$1"
    local dropbox_file="$2"
    response=$(curl -s -X POST "https://content.dropboxapi.com/2/files/upload" \
        --header "Authorization: Bearer $DB_ACCESS_TOKEN" \
        --header "Dropbox-API-Arg: {\"path\": \"$dropbox_file\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}" \
        --header "Content-Type: application/octet-stream" \
        --data-binary @"$local_file")
    
    

    if [ $? -eq 0 ]; then
        echo "Dropbox upload successful"
    else
        echo "Dropbox upload failed, received: $response"
        terminate
    fi
}

# Function to delete all files in a specific Google Drive folder
delete_all_files_in_googledrive_folder() {
    folder_id="$1"

    # List all files in the folder
    files_list=$(curl -s "https://www.googleapis.com/drive/v3/files?q='$folder_id'+in+parents" \
        --header "Authorization: Bearer $GD_ACCESS_TOKEN" \
        --header "Content-Type: application/json")

    # Check if the listing was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to list files in Google Drive folder."
        return 1
    fi

    # Extract file IDs and delete each file
    echo "$files_list" | grep -o '"id": "[^"]*' | grep -o '[^"]*$' | while read -r file_id; do
        delete_response=$(curl -s -X DELETE "https://www.googleapis.com/drive/v3/files/$file_id" \
            --header "Authorization: Bearer $GD_ACCESS_TOKEN")

        if [ $? -ne 0 ]; then
            echo "Error: Failed to delete file with ID $file_id."
        fi
    done
}

# Function to delete all files in a specific Dropbox folder
delete_all_files_in_dropbox_folder() {
    folder_path="$1"

    # List all files in the folder
    files_list=$(curl -s "https://api.dropboxapi.com/2/files/list_folder" \
        --header "Authorization: Bearer $DB_ACCESS_TOKEN" \
        --header "Content-Type: application/json" \
        --data "{\"path\": \"$folder_path\"}")

    # Check if the listing was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to list files in Dropbox folder."
        return 1
    fi

    # Extract file paths and delete each file
    echo "$files_list" | grep -o '"path_display": "[^"]*' | grep -o '[^"]*$' | while read -r file_path; do
        delete_response=$(curl -s -X POST "https://api.dropboxapi.com/2/files/delete_v2" \
            --header "Authorization: Bearer $DB_ACCESS_TOKEN" \
            --header "Content-Type: application/json" \
            --data "{\"path\": \"$file_path\"}")

        if [ $? -ne 0 ]; then
            echo "Error: Failed to delete file $file_path."
        fi
    done
}

get_dropbox_access_token() {
    local use_db2="$1"
    if [ -n "$DB_REFRESH_TOKEN" ]; then
        echo "Using stored Dropbox refresh token to obtain a new access token..."
        TOKEN_RESPONSE=$(curl -s "https://api.dropbox.com/oauth2/token" \
            -d refresh_token="$DB_REFRESH_TOKEN" \
            -d grant_type=refresh_token \
            -u "$DB_APP_KEY:$DB_APP_SECRET")

        DB_ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
        echo "New Dropbox access token obtained."
    else
        # Authorization code and token exchange steps here...
        echo $DB_AUTHORIZATION_URL
        read -p "Enter the authorization code after granting access: " DB_AUTHORIZATION_CODE

        # Step 2: Exchange the authorization code for an access token and refresh token
        TOKEN_RESPONSE=$(curl -s "https://api.dropbox.com/oauth2/token" \
            -d code="$DB_AUTHORIZATION_CODE" \
            -d grant_type=authorization_code \
            -u "$DB_APP_KEY:$DB_APP_SECRET")

        DB_ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
        DB_REFRESH_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.refresh_token')
        if [ "$use_db2" = true ]; then
            save_to_keychain "Ezra" "DropboxRefreshToken2" "$DB_REFRESH_TOKEN"
        else
            save_to_keychain "Ezra" "DropboxRefreshToken" "$DB_REFRESH_TOKEN"
        fi 
        echo "Dropbox access token and refresh token obtained."
    fi
}
get_google_access_token() {
    if [ -n "$GD_REFRESH_TOKEN" ]; then
        refresh_google_access_token
    else
        get_google_access_and_refresh_token
    fi
}

get_dropbox_access_token false
get_google_access_token
get_onedrive_access_token

echo "Deleting all files in Google Drive folder..."
delete_all_files_in_googledrive_folder "$GD_FOLDER_ID"

echo "Deleting all files in Dropbox folder..."
delete_all_files_in_dropbox_folder "$DESTINATION_DIR"

for file in "$LOCAL_DIRECTORY"/*; do
    if [[ -f $file ]]; then
        if [[ $file == *.tar ]]; then
            echo "WARNING: Uploading unencrypted .tar file"
            terminate
        fi
        base_name=$(basename "$file")
        dropbox_path="$DESTINATION_DIR/$base_name"
        echo "Uploading $file to Dropbox at $dropbox_path..."
        upload_to_dropbox "$file" "$dropbox_path"
        echo "Uploading $file to Google Drive..."
        upload_to_googledrive "$file"
        echo "Uploading $file to OneDrive..."
        upload_to_onedrive "$file"
    fi
done

echo "Upload CloudRestore completed."
rm Data.tar.gpg
cp ../Data.tar ./
gpg --batch --passphrase "$DB2_PASS" -c Data.tar
rm Data.tar
DB_APP_KEY=$DB2_APP_KEY
DB_APP_SECRET=$DB2_APP_SECRET
DB_AUTHORIZATION_URL=$DB2_AUTHORIZATION_URL
DB_REFRESH_TOKEN=$DB2_REFRESH_TOKEN

DESTINATION_DIR="/DataRestore/Data"      
get_dropbox_access_token false
echo "Deleting all files in Dropbox folder..."
delete_all_files_in_dropbox_folder "$DESTINATION_DIR"
for file in "$LOCAL_DIRECTORY"/*; do
    if [[ -f $file ]]; then
        if [[ $file == *.tar ]]; then
            echo "WARNING: Uploading unencrypted .tar file"
            terminate
        fi
        base_name=$(basename "$file")
        dropbox_path="$DESTINATION_DIR/$base_name"
        echo "Uploading $file to Dropbox at $dropbox_path..."
        upload_to_dropbox "$file" "$dropbox_path"
    fi
done

rm -rf $SCRATCH
cd $START
