import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class HtmlEditorExample extends StatefulWidget {
  final HtmlEditorController controller;
  const HtmlEditorExample({Key? key, required this.title, required this.controller}) : super(key: key);

  final String title;

  @override
  HtmlEditorExampleState createState() => HtmlEditorExampleState();
}

class HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          widget.controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (kIsWeb) {
                    widget.controller.reloadWeb();
                  } else {
                    widget.controller.editorController!.reload();
                  }
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.controller.toggleCodeView();
          },
          child: const Text(r'<\>', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlEditor(
                controller: widget.controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Digite seu texto aqui...',
                  shouldEnsureVisible: true,
                  //initialText: "<p>text content initial, if any</p>",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor, //by default
                  toolbarType: ToolbarType.nativeScrollable, //by default
                  onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                    print("button '${describeEnum(type)}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged:
                      (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                    print("dropdown '${describeEnum(type)}' changed to $changed");
                    return true;
                  },
                  mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                    print(file.name); //filename
                    print(file.size); //size in bytes
                    print(file.extension); //file extension (eg jpeg or mp4)
                    return true;
                  },
                ),
                otherOptions: const OtherOptions(height: 550),
                callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                  print('html before change is $currentHtml');
                }, onChangeContent: (String? changed) {
                  print('content changed to $changed');
                }, onChangeCodeview: (String? changed) {
                  print('code changed to $changed');
                }, onChangeSelection: (EditorSettings settings) {
                  print('parent element is ${settings.parentElement}');
                  print('font name is ${settings.fontName}');
                }, onDialogShown: () {
                  print('dialog shown');
                }, onEnter: () {
                  print('enter/return pressed');
                }, onFocus: () {
                  print('editor focused');
                }, onBlur: () {
                  print('editor unfocused');
                }, onBlurCodeview: () {
                  print('codeview either focused or unfocused');
                }, onInit: () {
                  print('init');
                },
                    //this is commented because it overrides the default Summernote handlers
                    /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                    onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                  print(describeEnum(error));
                  print(base64Str ?? '');
                  if (file != null) {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                  }
                }, onKeyDown: (int? keyCode) {
                  print('$keyCode key downed');
                  print('current character count: ${widget.controller.characterCount}');
                }, onKeyUp: (int? keyCode) {
                  print('$keyCode key released');
                }, onMouseDown: () {
                  print('mouse downed');
                }, onMouseUp: () {
                  print('mouse released');
                }, onNavigationRequestMobile: (String url) {
                  print(url);
                  return NavigationActionPolicy.ALLOW;
                }, onPaste: () {
                  print('pasted into editor');
                }, onScroll: () {
                  print('editor scrolled');
                }),
                plugins: [
                  SummernoteAtMention(
                      getSuggestionsMobile: (String value) {
                        var mentions = <String>['test1', 'test2', 'test3'];
                        return mentions.where((element) => element.contains(value)).toList();
                      },
                      mentionsWeb: ['test1', 'test2', 'test3'],
                      onSelect: (String value) {
                        print(value);
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller.undo();
                      },
                      child: const Text('Undo', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller.clear();
                      },
                      child: const Text('Reset', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () async {
                        var txt = await widget.controller.getText();
                        if (txt.contains('src=\"data:')) {
                          txt =
                              '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                        }
                        setState(() {
                          result = txt;
                        });
                      },
                      child: const Text(
                        'Submit',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        widget.controller.redo();
                      },
                      child: const Text(
                        'Redo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(result),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller.disable();
                      },
                      child: const Text('Disable', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () async {
                        widget.controller.enable();
                      },
                      child: const Text(
                        'Enable',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        widget.controller.insertText('Google');
                      },
                      child: const Text('Insert Text', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        widget.controller.insertHtml('''<p style="color: blue">Google in blue</p>''');
                      },
                      child: const Text('Insert HTML', style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () async {
                        widget.controller.insertLink('Google linked', 'https://google.com', true);
                      },
                      child: const Text(
                        'Insert Link',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        widget.controller.insertNetworkImage(
                            'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png',
                            filename: 'Google network image');
                      },
                      child: const Text(
                        'Insert network image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller.addNotification('Info notification', NotificationType.info);
                      },
                      child: const Text('Info', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller.addNotification('Warning notification', NotificationType.warning);
                      },
                      child: const Text('Warning', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () async {
                        widget.controller.addNotification('Success notification', NotificationType.success);
                      },
                      child: const Text(
                        'Success',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        widget.controller.addNotification('Danger notification', NotificationType.danger);
                      },
                      child: const Text(
                        'Danger',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        widget.controller
                            .addNotification('Plaintext notification', NotificationType.plaintext);
                      },
                      child: const Text('Plaintext', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      onPressed: () async {
                        widget.controller.removeNotification();
                      },
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
