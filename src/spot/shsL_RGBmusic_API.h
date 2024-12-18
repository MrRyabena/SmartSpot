#pragma once

#include <memory>

#include "shsL_RGBmusic.h"
#include "shsL_RGBmusic_API.h"

#include <shs_API.h>
#include <shs_ByteCollector.h>
#include <shs_ByteCollectorIterator.h>
#include <shs_DTPpacket.h>


namespace shs
{
    class RGBmusic_API;
}


class shs::RGBmusic_API : public shs::API
{
public:
    explicit RGBmusic_API(shs::RGBmusic& rgb_music, const shs::t::shs_ID_t id)
        : API(id), m_rgb_music(rgb_music)
    {}

    //API(API&& other) : API_ID(other.API_ID) { other.API_ID = {}; }

   //~API() = default;


    enum Commands : uint8_t
    {
        enable,
        disable,
        setEffect,
        getEffect,
        effect,
        setMinBright
    };


    void handle(shs::ByteCollectorReadIterator<>& it) override
    {
        ++it;

        switch (it.read())
        {
            case enable: m_rgb_music.start(); break;
            case disable: m_rgb_music.stop(); break;
            [[likely]] case setEffect:  m_rgb_music.setEffect(static_cast<shs::RGBmusic::Effects>(it.read())); break;
            case setMinBright: m_rgb_music.setMinBright(it.read());
            default: break;
        }
    }

private:
    shs::RGBmusic& m_rgb_music;
};
