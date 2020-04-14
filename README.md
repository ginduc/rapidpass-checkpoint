# RapidPass Checkpoint

## Documents
- [Design Specs](https://www.figma.com/file/jWgRtRX2FgOcfif5PBGxeI/RapidPass?node-id=1982%3A1419)
- [QR Code Specs](https://docs.google.com/document/d/13J-9MStDRL7thMm9eBgcSFU3X4b0_oeb3aikbhUZZAs/edit#heading=h.pflt6wulbxot)
- [Checkpoint Data Distribution Specs](https://docs.google.com/document/d/1V8lofHmv8ZhLZpcqJYu1TZoswn649KlcPhTXucFOa_k/edit#heading=h.5t6fdn38c9kh)

## Setup

### Tooling

|Name|Version|
|---|---|
|Flutter SDK|v1.12.13+hotfix.8 (stable|
|Dart SDK|> 2.7.0|
|Android Studio| > 3.5|
|Xcode| > 10.0|
|VSCode|Any|
|IntelliJ|Any|
 
### Running the project

1. Verify your Flutter and Dart SDK versions

Verify Flutter SDK installation

```
flutter doctor -v
```

Getting Dart SDK version

```
dart --version
```

2. Clone the project

```
git clone https://gitlab.com/dctx/rapidpass/rapidpass-checkpoint/
```

3. Run the project

To run in development:
```
flutter run -v --flavor dev -t lib/main-dev.dart
```

To run in production:
```
flutter run -v --flavor prod
```


### 


## Contributing

1. Please **visit** the [project board](https://gitlab.com/dctx/rapidpass/rapidpass-checkpoint/-/boards/1621773) and **assign** yourself a ticket
2. Create a new branch from the `develop` branch [1]
3. Please only commit the files that are relevant to the ticket you are working on
4. Push the changes to your branch

```
git push origin feature/99-added-profile-image
```

> NOTE: Do not push the changes directly to the `develop` branch.

5. Submit a merge request [2]
6. In the Slack channel, ask someone to review your code
7. If there are no issues, merge the branch yourself and delete the merge request branch
8. You deserve a pat on the back, celebrate!

[1] Creating a branch guidelines
- Naming convention, choose from: `feature`, `hotfix`:

Example:
```
git checkout -b hotfix/<ticket_no>-what-you-did
```
- `feature` - If you are an adding a new feature to the app
- `hotfix` - If you are working on quick-fixes/patches to ensure that the `develop` branch is buildable

[2] Merge request guidelines

- Details: Include a meaningful merge request description so the code reviewer code easily check what are the changes made
- Demo: If working on a UI or bug fix, it's recommended that you add a GIF or video in the merge request.

Template:

Example (copy and paste):

```
**Ticket**
- #ticket

**Changes**
- Some high-level change/s

**Attachments (if any)**

(upload or drag and drop files here)
```

## License

Please see [LICENSE](https://gitlab.com/dctx/rapidpass/rapidpass-checkpoint/LICENSE.md).