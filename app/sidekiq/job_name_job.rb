class JobNameJob
  include Sidekiq::Job

  def perform(*args)
    p 'hello this is the job'
  end
end
