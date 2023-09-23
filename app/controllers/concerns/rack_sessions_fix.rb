module RackSessionsFix
  extend ActiveSupport::Concern

  class FakeRackSession < Hash
    def enabled?
      false
    end

    # The 'destroy' method is intentionally left empty
    # because this fake session doesn't require any cleanup.
    # It's just a placeholder for the sake of compatibility.

    def destroy; end
  end

  included do
    before_action :set_fake_session

    private

    def set_fake_session
      request.env["rack.session"] ||= FakeRackSession.new
    end
  end
end
