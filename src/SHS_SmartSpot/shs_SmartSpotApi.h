#pragma once

#include <memory>

#include <shs_API.h>
#include <shs_ByteCollector.h>
#include <shs_DTPpacket.h>
#include <shs_types.h>
#include <shs_DTP.h>

#include "shs_SmartSpotInterface.h"
#include "shs_SmartSpotApiCommands.h"

namespace shs
{
    class SmartSpotApi;
}

class shs::SmartSpotApi : public shs::API
{
public:

    using Commands = shs::SmartSpotApiCommands;

    SmartSpotApi(std::shared_ptr<shs::SmartSpotInterface> spot, shs::t::shs_ID_t id);

    static void attachComponentsApi(std::shared_ptr<shs::DTP> dtp, std::shared_ptr<shs::SmartSpotInterface> spot, shs::t::shs_ID_t id);

    [[nodiscard]] shs::DTPpacket handle(shs::ByteCollectorReadIterator<>& it) override;

private:
    std::shared_ptr<shs::SmartSpotInterface> m_spot;

};
