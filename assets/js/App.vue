<template>
    <chat-app
            :messages="messages"
            :channels="channels"
            :current-channel="currentChannel"
            :current-user="user"
            :current-company="company"
            :users="users"
            @new-message="newMessage"
            @new-channel="newChannel"
            @join-channel="joinChannel"
            @logout="logout"
    />
</template>

<script>
  import {Presence} from 'phoenix'
  import { v4 } from 'uuid'

  import ChatApp from './components/ChatApp.vue';
  import {connector} from './socket'

  export default {
    components: {
      ChatApp
    },
    data() {
      return {
        messages: [],
        channels: [],
        currentChannel: null,
        user: null,
        company: null,
        users: [],
      };
    },
    socket: null,
    companyChannel: null,
    currentChannel: null,
    methods: {
      newMessage(message) {
        this.$options.currentChannel.push(`channels:${this.currentChannel.id}`, {
          message,
          uuid: v4(),
        });
      },
      newChannel(channel) {
        this.$options.companyChannel.push(`company:${window.currentCompanyId}`, {
          channel,
        });
      },
      joinChannel(channel) {
        if (this.currentChannel && this.currentChannel.id === channel.id) {
          return;
        }

        this.messages = [];
        this.currentChannel = channel;

        const socketChannel = this.$options.socket.channel(`channels:${channel.id}`);
        socketChannel.join();

        socketChannel.on(`channels:${channel.id}:new_message`, (message) => {
          this.messages.push(message);
        });

        this.$options.currentChannel = socketChannel
      },
      logout() {
        window.location = '/auth/logout';
      },
      syncUsers(presence) {
        let users = [];

        presence.list((id, {metas: [first, ...rest]}) => {
          users.push(first.user)
        });

        this.users = users;
      },
    },
    mounted() {
      const socket = connector(window.userToken);

      const channel = socket.channel(`company:${window.currentCompanyId}`)

      const presence = new Presence(channel)

      presence.onSync(() => {
        this.syncUsers(presence);
      });

      channel.join()
          .receive("ok", ({company, user, channels}) => {
            this.user = user;
            this.company = company;

            this.channels = channels;
          });

      channel.on(`company:${window.currentCompanyId}:new`, ({channel}) => {
        this.channels.push(channel);
      });

      this.$options.socket = socket;
      this.$options.companyChannel = channel;
    }
  }
</script>
