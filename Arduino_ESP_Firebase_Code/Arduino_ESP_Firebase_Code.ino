#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

//Insert your account credentials here


// Insert your network credentials here


// Insert Firebase project API Key
#define API_KEY "AIzaSyB_G8FCIQdkj_hZbEKd0gzNyYbVadrQHP4"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://fir-button-5ddf8-default-rtdb.europe-west1.firebasedatabase.app/"
#define D0 16
#define D1 5
#define D2 4

#define D4 2
#define D5 14
//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

bool signupOK = false;

void setup() {
  pinMode(D0, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  
  pinMode(D4, OUTPUT);
  pinMode(D5, OUTPUT);
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, USER_EMAIL, USER_PASSWORD)) {
    Serial.println("signup done");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  D0button();
  D1button();
  D2button();
  
  D4button();
  D5button();

}

void D0button() {
  int statD0;
  String sD0;
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/D0/Status")) {
      if (fbdo.dataType() == "int") {
        statD0 = fbdo.intData();
        if (statD0 == 0) {
          sD0 = "Off";
        }
        else if (statD0 == 1) {
          sD0 = "On";
        }
        Serial.println("D0 status = ");
        Serial.print(sD0);
        Serial.println();
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }

    if (statD0 == 0) {
      digitalWrite(D0, LOW);
      delay(1000);
    }
    else if (statD0 == 1) {
      digitalWrite(D0, HIGH);
      delay(100);
    }
  }
}
void D1button() {
  int statD1;
  String sD1;
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/D1/Status")) {
      if (fbdo.dataType() == "int") {
        statD1 = fbdo.intData();
        if (statD1 == 0) {
          sD1 = "Off";
        }
        else if (statD1 == 1) {
          sD1 = "On";
        }
        Serial.println("D1 status = ");
        Serial.print(sD1);
        Serial.println();
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }

    if (statD1 == 0) {
      digitalWrite(D1, LOW);
      delay(1000);
    }
    else if (statD1 == 1) {
      digitalWrite(D1, HIGH);
      delay(100);
    }
  }
}

void D2button() {
  int statD2;
  String sD2;
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/D2/Status")) {
      if (fbdo.dataType() == "int") {
        statD2 = fbdo.intData();
        if (statD2 == 0) {
          sD2 = "Off";
        }
        else if (statD2 == 1) {
          sD2 = "On";
        }
        Serial.println("D2 status = ");
        Serial.print(sD2);
        Serial.println();
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }

    if (statD2 == 0) {
      digitalWrite(D2, LOW);
      delay(1000);
    }
    else if (statD2 == 1) {
      digitalWrite(D2, HIGH);
      delay(100);
    }
  }
}
void D4button() {
  int statD4;
  String sD4;
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/D4/Status")) {
      if (fbdo.dataType() == "int") {
        statD4 = fbdo.intData();
        if (statD4 == 0) {
          sD4 = "Off";
        }
        else if (statD4 == 1) {
          sD4 = "On";
        }
        Serial.println("D4 status = ");
        Serial.print(sD4);
        Serial.println();
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }

    if (statD4 == 0) {
      digitalWrite(D4, LOW);
      delay(1000);
    }
    else if (statD4 == 1) {
      digitalWrite(D4, HIGH);
      delay(100);
    }
  }
}

void D5button() {
  int statD5;
  String sD5;
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/D5/Status")) {
      if (fbdo.dataType() == "int") {
        statD5 = fbdo.intData();
        if (statD5 == 0) {
          sD5 = "Off";
        }
        else if (statD5 == 1) {
          sD5 = "On";
        }
        Serial.println("D5 status = ");
        Serial.print(sD5);
        Serial.println();
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }

    if (statD5 == 0) {
      digitalWrite(D5, LOW);
      delay(1000);
    }
    else if (statD5 == 1) {
      digitalWrite(D5, HIGH);
      delay(100);
    }
  }
}
