// Copyright 2026 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2026 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

#define TIME_ARRAY_SIZE 5
long pressTime_ms[TIME_ARRAY_SIZE];
long releaseTime_ms[TIME_ARRAY_SIZE];
long currentTime_ms = -2;
int pressCounter = 0;
int releaseCounter = 0;
int currentButtonState = HIGH;
int previousButtonState = HIGH;
bool done = false;



void setup() {                
  // initialize the digital pin as an output.
  pinMode(13, OUTPUT); //LED on UNO R3  
  pinMode(9, INPUT_PULLUP);
  Serial.begin(9600);
  Serial.println("Hello!");

  for(int i =0; i < TIME_ARRAY_SIZE; i++)
  {
    pressTime_ms[i] = -1;
    releaseTime_ms[i] = -1;
  }
}


// the loop routine runs over and over again forever:
void loop() 
{
  if(done) return;

  if((pressCounter > TIME_ARRAY_SIZE) || (releaseCounter > TIME_ARRAY_SIZE))
  {
    done = true;
    // Display the times:
    Serial.println();
    Serial.println("--------------");
    for(int i =0; i < TIME_ARRAY_SIZE; i++)
    {
      Serial.print(i);
      Serial.print(": ");
      Serial.print(pressTime_ms[i]);
      Serial.print(", ");
      Serial.print(releaseTime_ms[i]);
      Serial.print(", ");
      Serial.println(releaseTime_ms[i]-pressTime_ms[i]);
    }
    Serial.println("Done!");
    Serial.println();
    Serial.println();
    Serial.println();
  }
  else
  {
    currentButtonState = digitalRead(9);
    currentTime_ms = millis();

    // Serial.print(currentTime_ms);
    // Serial.print(", ");
    // Serial.println(currentButtonState);

    if(currentButtonState == HIGH)
    {
      if(previousButtonState != currentButtonState) releaseTime_ms[releaseCounter++] = currentTime_ms;
      previousButtonState = currentButtonState;
      digitalWrite(13, LOW);
    }
    else // currentButtonState == LOW
    {
      if(previousButtonState != currentButtonState) pressTime_ms[pressCounter++] = currentTime_ms;
      previousButtonState = currentButtonState;
      digitalWrite(13, HIGH);
    }
  }
}
