import file from "@system.file";
import router from '@system.router';

export default {
    data: {
        title: 'Checking the os',
    },
}

file.access({
  uri: "internal://app",
  success: function () {
    console.log("The OS is not modded");
    router.replace({
      uri: "pages/list/index",
      params: {
        globalUri: "internal://app/qr",
      },
    });
  },
  fail: function (data, code) {
    console.log("The OS is modded");
    router.replace({
       uri: "pages/list/index",
       params: {
          globalUri: "/app/ace/data/com.adayup.QRCode/app/qr",
       },
    });
  },
});