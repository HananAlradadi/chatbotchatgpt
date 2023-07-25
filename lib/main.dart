import 'dart:convert';

import 'package:flutter/material.dart';
import 'model.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;
import 'package:http/http.dart' as http;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _textController = TextEditingController();
  //final _scrollController = ScrollController();
  late bool isLoading;
  TextEditingController _textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  final List <ChatMessage> _mees = [] ;
  bool isListein = false ;
  String text = "hanan" ;
  var  speechtotextVar = stts.SpeechToText() ;
  void speechtotext() async {
    if (! isListein){
      bool availabel = await  speechtotextVar.initialize(
        onStatus: (status) => print("$status"),
        onError: (Error) => print("$Error"),
        debugLogging: true,

      ) ;
      if (availabel){
        setState(() {
          isListein = true ;
        });
        speechtotextVar.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords ;
            print(text);

          }),
        );
      }
    }
    else {
      setState(() {
        isListein = false ;
      });
      speechtotextVar.stop();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false ;
    speechtotextVar = stts.SpeechToText() ;
  }
  //
  //Future<String> generateResponse(String qu) async{
  // final apikey = 'apiKey' ;
  // var url = Uri.https("api.openai.com" , "/vl/completions") ;
  // final response = await http.post(url ,
  // headers: {
  //  "Content-Type" : "application.json" ,
//    'Authorization' : 'Bearer $apikey'
  //      } ,
  //  body: jsonEncode({
  //    'model' : 'text-davinci-003' ,
  //    'prompt' : qu ,
  //    'temperature' : 0 ,
  //    'max_token' : 2000 ,
  //    'top_p' : 1 ,
  //    'frequency_penalty' : 0.0 ,
//    'presence_penalty' : 0.0
//    })) ;
    // عشان أقدر أحصل على الاجابة
  //}
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(


        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "OpenAI's ChatGPT Flutter Example \n@ngjunya",
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),


      body: Column(
         children: [
           // الشات
           Expanded(child: _buildList()),
           Visibility(
             visible: isLoading,

               child: Padding(

             padding: const EdgeInsets.all(8.0),
             child: CircularProgressIndicator(
               color: Colors.cyan,
             ),
           )
           )
          , Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(children:[
              // take input from user
               _buildInput() ,

               _buildSubmit() ,
              _buildSubmitVoise()


             ]



            ),
          )
         ],

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Expanded _buildInput(){
    return Expanded(child: TextField (
    textCapitalization: TextCapitalization.sentences ,
      style: TextStyle(color: Colors.black),
      controller: _textEditingController ,
      decoration: InputDecoration(
        fillColor: Colors.cyan ,
            filled: true ,
        border: InputBorder.none ,
        focusedBorder: InputBorder.none ,
        enabledBorder: InputBorder.none ,
        errorBorder: InputBorder.none ,
        disabledBorder: InputBorder.none ,


      ) ,

    )
    );
  }
  Widget _buildSubmit() {
   return Visibility(
       visible: ! isLoading,
       child: Container( child: IconButton(icon: Icon(Icons.send_rounded),

     onPressed: (){},


   ) ,


   ));
  }
  Widget _buildSubmitVoise(){
    return Visibility(
        child: FloatingActionButton(onPressed: (){
      speechtotext();
            },
            child: Icon(isListein? Icons.mic : Icons.mic_none ,
            ) ,

          ));


  }

  ListView _buildList(){

    return ListView.builder( itemCount: _mees.length ,
        controller: _scrollController
        ,itemBuilder: ((context , index){
          var message = _mees[index] ;

      return ChatMessageWidget(
        text: message.text,
        chatMessageType: message.chatMessageType ,
      );

    })) ;
    }
  }
  class ChatMessageWidget extends StatelessWidget {
  final String text ;
  final ChatMessageType chatMessageType;
    const ChatMessageWidget({ super.key , required this.text , required this.chatMessageType



    }) ;
  
    @override
    Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 10 ,

        ),
        padding: EdgeInsets.all(16),
        color: chatMessageType == ChatMessageType.bot ?Colors.brown : Colors.deepPurple ,
        child: Row (children: [
          chatMessageType == ChatMessageType.bot ? Container(
            margin: EdgeInsets.only(right: 16) ,
            child: CircleAvatar (backgroundColor: Colors.blue, child: Image.asset("images/bot.png"
            , color: Colors.white,
              scale: 1.5,
            ),) ,
          ) : Container(
             margin: EdgeInsets.only(right: 16 ) ,
            child: CircleAvatar(child: Icon(Icons.person),
            ),
          ) ,
          Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Container(
                    padding: EdgeInsets.all(8) ,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8),

                      ))
                    , child: Text(text , style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue)),
                  )
                ]
              )
          )
        ],) ,
      );
    }
  }
  

