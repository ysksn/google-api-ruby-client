require 'spec_helper'

RSpec.describe Google::Apis::Error do
  describe '.new' do
    subject { described_class.new(error) }

    context 'first arg is a string which does not respond to :backtrace' do
      let(:error) { 'an error occurred' }

      it 'creates a instance of error with message' do
        expect(subject.message).to eq 'an error occurred'
      end
    end

    context 'first arg responds to :backtrace' do
      let(:error) { double }

      it 'creates a instance of error with message' do
        allow(error).to receive(:respond_to?).with(:backtrace) { true }
        allow(error).to receive(:message) { 'error message' }
        expect(subject.message).to eq 'error message'
      end
    end

    describe 'rest of args :body, :header, and :status_code' do
      let(:error) { 'an error occurred' }

      context 'params :body, :header, and :status_code are not given' do
        it 'instance variables @body, @header, and @status_code will be nil' do
          expect(subject.body).to be_nil
          expect(subject.header).to be_nil
          expect(subject.status_code).to be_nil
        end
      end

      context 'params :body, :header, and :status_code are given' do
        subject do
          described_class.new(
            error,
            body:       'this is body',
            header:     'this is header',
            status_code: 200)
        end

        it 'instance variables @body, @header, and @status_code will not be nil' do
          expect(subject.body).to eq 'this is body'
          expect(subject.header).to eq 'this is header'
          expect(subject.status_code).to eq 200
        end
      end
    end
  end

  describe '#backtrace' do
    subject { described_class.new('error') }
    let(:cause) { instance_double('Error', backtrace: 'this is backtrace') }

    context '@cause is truthy' do
      it 'returns @cause.backtrace' do
        subject.instance_variable_set(:@cause, cause)
        expect(subject.backtrace).to eq 'this is backtrace'
      end
    end

    context '@cause is falsy' do
      it 'returns super' do
        subject.instance_variable_set(:@cause, false)
        expect(subject.backtrace).to be_nil
      end
    end
  end
end
