use Mix.Config

alias Squadster.Workers

config :squadster, Squadster.Workers,
  timeout: 30_000,

  jobs: [
    # shift duty queues every day at 01:00 am
    shift_queue_numbers: [
      schedule: "0 1 * * *",
      task: {Workers.ShiftQueueNumbers, :start, []}
    ],
    # remind about duty every midday
    notify_attendants: [
      schedule: "0 12 * * *",
      task: {Workers.NotifyAttendants, :start, []}
    ]
  ]
