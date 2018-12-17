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
    import { connector } from './socket'

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
        socket: null,
        companyChannel: null,
        methods: {
            newMessage(msg) {
                console.log(msg)

            },
            newChannel(channel) {
                this.$options.companyChannel.push(`company:${window.currentCompanyId}`, {
                    channel,
                });
            },
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
                window.location = '/auth/logout';
            }
        },
        mounted() {
            const socket = connector(window.userToken);

            const channel = socket.channel(`company:${window.currentCompanyId}`)

            channel.join()
                .receive("ok", ({company, user, channels}) => {
                    this.user = user;
                    this.company = company;
                    this.users = [user];

                    this.channels = channels;
                })

            channel.on(`company:${window.currentCompanyId}:new`, ({channel}) => {
                this.channels.push(channel);
            });

            this.$options.socket = socket;
            this.$options.companyChannel = channel;
        }
    }
</script>
