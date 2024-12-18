#pragma once


/*
    The idea and code are taken from Alex Gyver's project:
    https://github.com/AlexGyver/ColorMusicRGB
*/


#include <VolAnalyzer.h>  // https://github.com/GyverLibs/VolAnalyzer
#include <GRGB.h>         // https://github.com/GyverLibs/GRGB

#include <shs_Process.h>
#include <Arduino.h>


namespace shs {
class RGBmusic;
}


class shs::RGBmusic  //: public shs::Process {
{
public:
  enum Effects : uint8_t { OFF,
                           SHIFT_151,
                           SHIFT_129,
                           PULSE_WHEEL,
                           FIRE } effect;

  VolAnalyzer analyzer;
  GRGB& grgb;

  RGBmusic(GRGB& set_grgb, const int8_t port = -1)
    : grgb(set_grgb), analyzer(port) {}

  void setEffect(const Effects eff) {
    effect = eff;
  }

  void setMinBright(const uint8_t br) {
    m_min_bright = br;
  }

  void start() {
    grgb.fadeMode(false);
  }

  void tick() {

    if (effect == OFF) return;

    if (!analyzer.tick()) return;

    yield();

    switch (effect) {
      case SHIFT_151:
        if (analyzer.pulse()) color += 151;
        grgb.setWheel8(color, m_min_bright + analyzer.getVol() >= 255 ? 255 : m_min_bright + analyzer.getVol());
        break;
      case SHIFT_129:
        if (analyzer.getPulse()) color += 129;
        grgb.setWheel8(color, m_min_bright + analyzer.getVol() >= 255 ? 255 : m_min_bright + analyzer.getVol());
        break;
      case PULSE_WHEEL:
        grgb.setWheel8(color++, m_min_bright + analyzer.getVol() >= 255 ? 255 : m_min_bright + analyzer.getVol());
        break;
      case FIRE:
        grgb.setHSVfast((analyzer.getVol() - 10) / 6, 255, m_min_bright + analyzer.getVol() >= 255 ? 255 : m_min_bright + analyzer.getVol());
        break;
      default: break;
    }
  }

  void stop() {
    effect = OFF;
    grgb.setRGB(0, 0, 0);
  }
private:
  uint8_t color{};
  uint8_t m_min_bright{};
};
