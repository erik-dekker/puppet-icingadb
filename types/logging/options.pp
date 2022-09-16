type IcingaDB::Logging::Options = Struct[{
  Optional[config-sync]       => IcingaDB::Logging::Level,
  Optional[database]          => IcingaDB::Logging::Level,
  Optional[dump-signals]      => IcingaDB::Logging::Level,
  Optional[heartbeat]         => IcingaDB::Logging::Level,
  Optional[high-availability] => IcingaDB::Logging::Level,
  Optional[history-sync]      => IcingaDB::Logging::Level,
  Optional[overdue-sync]      => IcingaDB::Logging::Level,
  Optional[redis]             => IcingaDB::Logging::Level,
  Optional[retention]         => IcingaDB::Logging::Level,
  Optional[runtime-updates]   => IcingaDB::Logging::Level,
  Optional[telemetry]         => IcingaDB::Logging::Level,
}]
