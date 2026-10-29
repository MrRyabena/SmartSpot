#pragma once

#include <stdint.h>

namespace shs
{
    enum class SmartSpotApiCommands : uint8_t
    {
        NO_COMMAND,
        GET_FAN,
        SET_FAN,
        FAN,
    };
}
