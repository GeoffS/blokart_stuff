// Copyright 2026 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2026 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

#include <TimerOne.h>

#define HIGH_BUTTON_STATE_ACCUMULATOR_VALUE 50
#define LOW_BUTTON_STAT_ACCUMULATOR_VALUE 0

int debouncedButtonState =          HIGH;
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

    // Check to see if the currentButtonStateAccumulator has reached either threhold:
    if(currentButtonStateAccumulator >= HIGH_BUTTON_STATE_ACCUMULATOR_VALUE)
    {
      currentButtonStateAccumulator = HIGH_BUTTON_STATE_ACCUMULATOR_VALUE;
      debouncedButtonState = HIGH;
    }
    else if(currentButtonStateAccumulator <= LOW_BUTTON_STAT_ACCUMULATOR_VALUE)
    {
      currentButtonStateAccumulator = LOW_BUTTON_STAT_ACCUMULATOR_VALUE;
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
}
