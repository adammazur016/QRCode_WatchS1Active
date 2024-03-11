import file from "@system.file";
import router from '@system.router';
import interconnect from "@system.interconnect";

let globalUri = "";

function writeTxtToFile(myText, myFilename){
    file.writeText({
      uri: globalUri + "/" + myFilename,
      text: myText,
      success: function () {
        console.log("F");
        router.replace({
          uri: "pages/list/index",
          params: {
            globalUri: globalUri,
          },
        });
      },
      fail: function (data, code) {
        console.error("call fail callback fail, code: " + code + ", data: " + data);
      },
    });
}

//creating QR Directory

function setup(das){
    file.mkdir({
        uri: globalUri,
        success: function () {
           console.log("Created QR file directory");
           das.title = "Created QR file directory";
        },
        fail: function (data, code) {
           console.error("Couldn't create QR Directory");
           das.title = globalUri;
        },
    });
}



var array = [];
var fileArrayData = [];

function testFunction(value){
    var currentUri = value.uri;
    console.log("In test function current uri is: " + currentUri);
    var fileArray = currentUri.split("/");
    var myFilename = fileArray[fileArray.length - 1];
    myFilename = myFilename.slice(0, -4);
    array.push({uri: currentUri, filename: myFilename});
}

function synch(das){
   das.discoveredFiles = [];
   file.list({
       uri: globalUri,
       success: function (data) {
            var files = data.fileList;
            array = [];
            files.forEach(testFunction);
       },
   });
   das.discoveredFiles = array;
   console.log("Discovered files: " + JSON.stringify(das.discoveredFiles));
}

function hide(){
    router.replace({
       uri: "pages/list/index",
       params: {
          globalUri: globalUri,
       },
    });
}

export default {
    data: {
        title: 'Logs get here',
        discoveredFiles: [],
        connect: interconnect.instance(),
    },

    onInit(){
        globalUri = this.globalUri;
        setup(this);
        let to = this;
        var intervalID = setInterval(function () {
          synch(to);
          console.log("Array length is: " + to.discoveredFiles.length);
          if(to.discoveredFiles.length > 0) {
            clearInterval(intervalID);
            hide();
          }
        }, 50);
        this.connect.onmessage = (data) => {
          let msg = data.data;
          let msgArr = msg.split(";");
          let newFileName = msgArr[0];
          let newFileContent = msgArr[1];
          writeTxtToFile(newFileContent, newFileName);
        }
    },

}

