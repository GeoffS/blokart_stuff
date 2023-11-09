#include <Adafruit_NeoPixel.h>

// set to pin connected to data input of WS8212 (NeoPixel) strip
#define PIN         2

// number of LEDs (NeoPixels) in your strip
// (please note that you need 3 bytes of RAM available for each pixel)
#define NUM_PIXELS   24

// USB_POWER = 0 -> Full intensity LEDs
// USB_POWER = 1 -> Low intensity LEDs for running off the programming USB port's power.
// #define USB_POWER 1

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800);

void post(uint8_t r, uint8_t g, uint8_t b)
{
  for (int pos_index=0; pos_index<NUM_PIXELS; pos_index++) 
  {
    for (int pixel_index=0; pixel_index<NUM_PIXELS; pixel_index++) 
    {
      if(pos_index == pixel_index) strip.setPixelColor(pixel_index, r, g, b);
      else strip.setPixelColor(pixel_index, 0, 0, 0);
    }
    strip.show();
    delay(30);
  }
}

void setup() 
{
  // Init. the built-in LED:
  pinMode(1, OUTPUT);

  // initialize LED strip
  strip.begin();
  strip.show();

  #if USB_POWER
  for(int i=0; i<NUM_POINTS; i++)
  {
    r[i] = r[i]/4;
    g[i] = g[i]/4;
    b[i] = b[i]/4;
  }
  #endif

  digitalWrite(1, HIGH);
  post(64, 0, 0);
  digitalWrite(1, LOW);
  post(0, 64, 0);
  digitalWrite(1, HIGH);
  post(0, 0, 64);
  digitalWrite(1, LOW);
}

int start_pos = -NUM_POINTS;
bool led_state = true;

void loop() 
{
  delay(15);
  // if(start_pos == 0) delay(7000);

  if(start_pos >= NUM_PIXELS) 
  {
    start_pos = -NUM_POINTS;

    if(led_state) digitalWrite(1, HIGH);
    else          digitalWrite(1, LOW);
    led_state = !led_state;
  }

  // now iterate over each pixel and calculate it's color
  for (int pixel_index=0; pixel_index<NUM_PIXELS; pixel_index++) 
  {
    int point_index = pixel_index - start_pos;

    if(point_index < 0)
    {
      strip.setPixelColor(pixel_index, 0, 0, 0);
    }
    else if(point_index < NUM_POINTS)
    {
      strip.setPixelColor(pixel_index, r[point_index], g[point_index], b[point_index]);
    }
    else
    {
      strip.setPixelColor(pixel_index, 0, 0, 0);
    }
  }

  // send data to LED strip
  strip.show();

  start_pos++;
}





