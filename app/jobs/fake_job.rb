class FakeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    p ' --|-- --|-- FAKE JOB STARTING --|-- --|--'
    sleep 3
    p '--|-- --|-- Ok JOB IS DONE--|-- --|-- '
  end
end
