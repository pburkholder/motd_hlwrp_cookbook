require_relative 'spec_helper'
describe Chef::Provider::Motd do
  let(:new_resource) { Chef::Resource::Motd.new('newname') }
  let(:node) { Chef::Node.new() }
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node,{},events) }
  let(:current_resource) { Chef::Resource::Motd.new('newname') }

  subject(:provider) {
    Chef::Provider::Motd.new(new_resource, run_context)
  }

  before do # Needed when determining current_resource state
    provider.stub(:load_current_resource).and_return(current_resource)
    provider.new_resource = new_resource
    provider.current_resource = current_resource
  end

  it 'should be instantiated' do
    provider.should respond_to(:new_resource)
    provider.should respond_to(:run_context)
  end

  it 'should have the right name' do
    provider.new_resource.name.should match(/newname/)
  end

  context 'when motd does not exist' do
    before do
      ::File.stub(:exists?).with('/etc/motd').and_return(false)
    end

    it 'should log an info message' do
      Chef::Log.should_receive(:info)
      provider.run_action(:create)
    end
  end

  context 'when motd already exists' do
    before do
      ::File.stub(:exists?).with('/etc/motd').and_return(true)
    end

    it 'should log a debug messag' do
      Chef::Log.should_receive(:debug)
      provider.run_action(:create)
    end
  end
end
