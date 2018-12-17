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
    import ChatApp from './components/ChatApp.vue';

    export default {
        components: {
            ChatApp
        },
        data () {
            return {
                messages: [],
                channels: [],
                currentChannel: null,
                user: null,
                company: null,
                users: [],
            };
        },
        methods: {
            newMessage() {},
            newChannel() {},
            joinChannel(channel) {
                console.log(channel);
                /**
                if (this.currentChannel && this.currentChannel.id === channel.id) {
                    return;
                }

                if (this.currentChannel) {
                    Echo.leave(`channels.${this.currentChannel.id}`);
                }

                try {
                    Echo.private(`channels.${channel.id}`)
                        .listen('NewMessage', (e) => {
                            this.$store.commit({
                                type: NEW_MESSAGE,
                                message: e,
                            });
                        });

                    this.$store.commit({
                        type: JOINED_CHANNEL,
                        channel
                    });
                } catch (e) {
                    console.log(e);
                }
                 */
            },
            logout() {
                console.log('logout')
            }
        },
        mounted() {
            /** 
            Echo.join(`companies.${window.Laravel.company.id}`)
                .here((users) => {
                    this.$store.commit({
                        type: LOAD_USERS,
                        users,
                    });
                })
                .joining((user) => {
                    this.$store.commit({
                        type: USER_JOINED,
                        user,
                    });
                })
                .leaving((user) => {
                    this.$store.commit({
                        type: USER_LEFT,
                        user,
                    });
                })
                .listen('ChannelCreated', (e) => {
                    this.$store.commit({
                        type: NEW_CHANNEL,
                        channel: e.channel
                    });
                });
            */
        }
    }
</script>
