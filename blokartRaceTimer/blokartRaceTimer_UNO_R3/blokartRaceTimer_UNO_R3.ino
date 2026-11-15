// Copyright 2026 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2026 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(13, OUTPUT); //LED on UNO R3  
}

// the loop routine runs over and over again forever:
void loop() {
  // digitalWrite(0, HIGH);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(13, HIGH);
  delay(200);               // wait for a second
  // digitalWrite(0, LOW);    // turn the LED off by making the voltage LOW
  digitalWrite(13, LOW); 
  delay(400);               // wait for a second
}
