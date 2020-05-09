use Mix.Config

alias Squadster.Workers

config :squadster, Squadster.Workers,
  timeout: 30_000,

  jobs: [
    # shift duty queues every day at 01:00 am
    shift_queues: [
      schedule: "0 1 * * *",
      task: {Workers.ShiftQueues, :start_link, []}
    ],
    # remind about duty every midday
    notify_duties: [
      schedule: "0 12 * * *",
      task: {Workers.NotifyDuties, :start_link, []}
    ]
  ]
