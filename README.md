# Music

## Project Description
Music is a music player written in flutter for CS50 final project. It has support for android and linux and may work on windows (Untested).

## File Description
### main.dart
- Starts the application
- Setups up the providers for the application
- Requests storage access if on Android
- Prompts directory selction if on other platforms

### Pages
The pages folder contains all the pages ie. the different views of the application.

#### player.dart
- UI of the player that plays music
- Contains AuidoPlayer instance
- Obtains file from playlist provider (provider is a state manager explained more below)
- Displays album art, track name, artist name obtained from metadata provider
- Play, pause, resume, seek, skip functionality implemented
- Music skips to next upon completion
- Looping and shuffling

#### list.dart
- List item for displaying all the music
- Plays the corresponding music when clicked
- Sets information in metadata provider if not present
- Displays album art, track name, artist name obtained from metadata provider
- Hilighted if it is the music currently being played

#### music_list.dart
- Loads music files from the device (only mp3 for now)
- Sets metadata for all the files
- Adds files sorted files in the files provider and playlist provider
- Displays list for all the files from files provider

#### home.dart
- Contains music list and floating button
- Floating button shows the music being played if being played
- Floating  button can be clicked to go to the music page

### Providers
Providers are classes that store the state of the application. They extend the change notifier which can send a notification when some state is changed. Any widget can listen to the providers which will update the data that they are displaying. Providers also provider methods to change the data stored in them.
#### files_provider.dart
- Used to access list of music files
- Can add multiple files or single file

#### metadata_provider.dart
- Class RequiredMetadata defined
- RequiredMetadata contains track name, artist name, track duration and album art of the music
- Provider returns a map with the file path as the key and RequiredMetadata as the value
- Can add more key value pairs to map

#### player_provider.dart
- Contians the page of the player which is currently being played
- Can change the page

#### player_status_provider.dart
- Contains information about the music currently being played
- Information includes the current position of the music, percentage of music completed, if the music is currently playing and it the music should repeat or not.
- Also stores metadata obtained from metadata provider
- Can set all the information to default values
- Can changes the current position and percentage completed
- Can play and pause the music
- Can change whether to repeat the music or not

#### playlist_provider.dart
- Used to access list of music and path of currently playing music
- Returns shuffled music or music ordered alphabetically based on the mode
- Can add files to playlist
- Can shuffle the playlist
- Can set the path of current music

### Utils

#### directory_selector.dart
- Allows for directory selection
- Checks for saved directory
- Returns saved directory if exists
- If not, prompts for selection and saves directory

#### find_music_files.dart
- Takes directory as argument and finds music files (only mp3 for now)

#### format_data.dart
- Contains functions for formatting data to be displayed a certain way

#### metadata.dart
- Uses metadata god to get metadata of music files
- Returns a RequiredMetadata object which contains artist name, track name, track duration and the album art

## To Do
- [x]  Playing from local file
- [x]  Pause, Resume, Seek etc.
- [x]  Skip next and previous
- [x]  Load Multiple Files
- [x]  Autoskip on completion
- [x]  Background Play
- [ ]  Permanent Notification
- [ ]  Background Autoskip
- [ ]  Search
- [ ]  Create Playlists
- [ ]  Good Looking Interface
Currently, stuck on background autoskip. I've tried multiple approaches with varying levels of success. Remaining taks on the todo list are on hold until I can figure it out.

## Video Url: https://youtu.be/cleOfCcZPQI
