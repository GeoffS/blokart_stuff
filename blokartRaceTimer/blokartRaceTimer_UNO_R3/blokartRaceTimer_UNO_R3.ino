// Copyright 2026 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2026 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

#include <TimerOne.h>

#define TIME_ARRAY_SIZE 10
long pressTime_ms[TIME_ARRAY_SIZE];
long releaseTime_ms[TIME_ARRAY_SIZE];
long currentTime_ms = -2;
int pressCounter = 0;
int releaseCounter = 0;
// int currentButtonState = HIGH;
int debouncedButtonState = HIGH;
bool keepLogging = true;

#define HIGH_BUTTON_STATE_ACCUMULATOR_VALUE 50
#define LOW_BUTTON_STAT_ACCUMULATOR_VALUE 0
int currentButtonStateAccumulator = HIGH_BUTTON_STATE_ACCUMULATOR_VALUE;

void timerCallback() 
{
    // Update the currentButtonStateAccumulator based on the 
    // button pin's value:
    if(digitalRead(9) == HIGH)
    {
      currentButtonStateAccumulator++;
    }
    else // digitalRead(9) == LOW
    {
      currentButtonStateAccumulator--;
    }

    currentTime_ms = millis();

    if(currentButtonStateAccumulator >= HIGH_BUTTON_STATE_ACCUMULATOR_VALUE)
    {
      currentButtonStateAccumulator = HIGH_BUTTON_STATE_ACCUMULATOR_VALUE;
      if(debouncedButtonState != HIGH) releaseTime_ms[releaseCounter++] = currentTime_ms;
      debouncedButtonState = HIGH;
    }
    else if(currentButtonStateAccumulator <= LOW_BUTTON_STAT_ACCUMULATOR_VALUE)
    {
      currentButtonStateAccumulator = LOW_BUTTON_STAT_ACCUMULATOR_VALUE;
      if(debouncedButtonState != LOW) pressTime_ms[pressCounter++] = currentTime_ms;
      debouncedButtonState = LOW;
    }
}

void setup() 
{                
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

  // Intialize a 1ms timer for button debounce.
  Timer1.initialize(1000); // Set interval in microseconds (1000 µs = 1 ms)
  Timer1.attachInterrupt(timerCallback);
}

// the loop routine runs over and over again forever:
void loop() 
{
  // Load the LED to reflect the button-state:
  if(debouncedButtonState == HIGH) digitalWrite(13,  LOW);
  else                             digitalWrite(13, HIGH);

  if(keepLogging)
  {
    if((pressCounter > TIME_ARRAY_SIZE) || (releaseCounter > TIME_ARRAY_SIZE))
    {
      keepLogging = false;
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
  }
}
