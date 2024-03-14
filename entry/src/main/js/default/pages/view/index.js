import file from "@system.file";
import router from '@system.router';

let QRTextFromFile = "";

function getTextFromFile(value) {
    file.readText({
      uri: value,
      success: function (data) {
        QRTextFromFile = data.text;
        console.log("THE TEXT IS: " + data.text);
      },
    });
}

export default {
    data: {
        title: "hej",
        QRString: "wait",
    },

    onInit(){
        this.title = this.napis;
        let to = this;

        getTextFromFile(this.title);
        var intervalID = setInterval(function () {
            to.QRString = QRTextFromFile;
            console.log("Ustawiono napis: " + to.QRString);
            if(to.QRString.length > 0) {
                clearInterval(intervalID);
            }
        }, 50);
    },

    back(){
        router.back();
    }

};

