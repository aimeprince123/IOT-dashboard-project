#include <SPI.h>
#include <MFRC522.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>
Servo myservo;
#define SS_PIN 10
#define RST_PIN 9
#define RELAY_PIN 7   // Relay control pin

MFRC522 rfid(SS_PIN, RST_PIN);
LiquidCrystal_I2C lcd(0x27, 16, 2); // Adjust 0x27 if your LCD uses a different I2C address

// Example of an allowed UID (replace with your card’s UID)
byte allowedUID[4] = {0x01, 0x02, 0x03, 0x04};

void setup() {
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW); // Relay OFF initially

  lcd.init();       // Initialize LCD
  lcd.backlight();  // Turn on backlight
  lcd.setCursor(0, 0);
  lcd.print("Scan RFID card");
  myservo.attach(5);
}

void loop() {
  if (!rfid.PICC_IsNewCardPresent()) return;
  if (!rfid.PICC_ReadCardSerial()) return;

  Serial.print("Card UID: ");
  bool match = true;
  for (byte i = 0; i < rfid.uid.size; i++) {
    Serial.print(rfid.uid.uidByte[i] < 0x10 ? " 0" : " ");
    Serial.print(rfid.uid.uidByte[i], HEX);

    if (rfid.uid.uidByte[i] != allowedUID[i]) {
      match = false;
    }
  }
  Serial.println();

  if (match) {
    Serial.println("Access Granted - Relay ON");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Access Granted");
    digitalWrite(RELAY_PIN, HIGH);
    myservo.write(90); // Turn relay ON
    delay(5000);                   // Keep ON for 5 seconds
    digitalWrite(RELAY_PIN, LOW); 
    myservo.write(0); // Turn relay OFF
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Scan RFID card");
  } else {
    Serial.println("Access Denied - Relay OFF");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Access Denied");
    digitalWrite(RELAY_PIN, LOW);
    myservo.write(0);
    delay(2000);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Scan RFID card");
  }

  rfid.PICC_HaltA();
}