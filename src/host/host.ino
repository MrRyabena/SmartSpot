#include <ESP8266WiFi.h>


constexpr char ssid[] = "SHS_WiFi_2";
constexpr char password[] = "28841971";

WiFiServer server(50);


void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    if (millis() >= 30000) ESP.restart();
  }

  server.begin();
}

char buf[20];

void loop() {
  WiFiClient client = server.available();

  if (client) {
    Serial.println("CL");
    while (client.connected()) {
     while (client.available()) {
      Serial.write(client.read());
      yield();
     }
      while (Serial.available()) {
        client.write(Serial.read());
        yield();
      }
      yield();
    }
  }
}
