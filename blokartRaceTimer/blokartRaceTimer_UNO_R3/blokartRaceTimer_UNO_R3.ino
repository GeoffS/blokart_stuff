// Copyright 2026 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2026 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

void setup() {                
  // initialize the digital pin as an output.
  pinMode(13, OUTPUT); //LED on UNO R3  
  pinMode(9, INPUT_PULLUP);
}

// the loop routine runs over and over again forever:
void loop() {
  if(digitalRead(9) == HIGH)
  {
    digitalWrite(13, LOW);
  }
  else
  {
    digitalWrite(13, HIGH);
  }
}
