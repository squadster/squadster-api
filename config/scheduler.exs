use Mix.Config

alias Squadster.Workers

config :squadster, Squadster.Workers,
  timeout: 30_000,

  jobs: [
    # shift duty queues every midnight
    shift_queue_numbers: [
      schedule: "@daily",
      task: {Workers.ShiftQueueNumbers, :start, []}
    ],
    # remind about duty every midnight
    notify_attendants: [
      schedule: "@daily",
      task: {Workers.NotifyAttendants, :start, []}
    ]
  ]
