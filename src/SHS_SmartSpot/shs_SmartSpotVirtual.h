#pragma once

#include <shs_API.h>
#include <shs_types.h>
#include <shs_DTP.h>
#include <shs_DTPpacket.h>
#include <shs_ByteCollectorIterator.h>
#include <shs_ProgramTimer.h>
#include <shs_SensorVirtual.h>

#include <shs_lib_Color_RgbManager.h>
#include <shs_lib_Color_RgbManagerVirtual.h>

#include "shs_SmartSpotInterface.h"

namespace shs
{
    class SmartSpotVirtual;
}


class shs::SmartSpotVirtual : public shs::SmartSpotInterface, public shs::API, public shs::Process
{
public:
    static constexpr auto MAX_REQUEST_COUNT = 6;
    static constexpr auto REQUEST_TIMEOUT = 2500;

    explicit SmartSpotVirtual(std::shared_ptr<shs::DTP> dtp, shs::t::shs_ID_t id, shs::t::shs_ID_t remote_id);

    bool isConnected() const noexcept { return m_request_counter < MAX_REQUEST_COUNT; }
    void requestFanPower();

    void start() override {}
    void tick() override;
    void stop() override {}

    [[nodiscard]] shs::DTPpacket handle(shs::ByteCollectorReadIterator<>& it) override;

    [[nodiscard]] std::shared_ptr<shs::lib::Color::RgbManager> getManager() override;
    [[nodiscard]] std::shared_ptr<shs::Sensor> getTemperatureSensor() override;
    [[nodiscard]] uint8_t getFanPower() override { return m_fan_power; }
    [[nodiscard]] uint8_t getFanMode() override { return m_fan_mode; }
    void setFan(uint8_t value, uint8_t mode = 0) override;
protected:
    std::shared_ptr<shs::DTP> m_dtp;
    std::shared_ptr<shs::lib::Color::RgbManagerVirtual> m_manager;
    std::shared_ptr<shs::SensorVirtual> m_temperature_sensor;
    shs::ProgramTimer m_request_timer;
    shs::t::shs_ID_t m_remote_id;
    uint8_t m_fan_power{};
    uint8_t m_fan_mode{};
    uint8_t m_request_counter{};
};
