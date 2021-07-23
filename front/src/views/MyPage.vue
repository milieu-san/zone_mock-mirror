<template>
  <v-container>
    <v-row>
      <v-col cols="12" class="align-center">
        <v-card
          class="mx-auto"
          max-width="960"
        >
          <v-container>
            <v-row
              v-if="currentUser"
              justify="center" align="center"
            >
              <v-col cols="4" align="center">
                <IconUser
                  :id="currentUser.id"
                  :name="currentUser.name"
                  :size="56"
                  text-size="text-h5"
                />
              </v-col>
              <v-col cols="5" class="pl-0">
                <v-card-text class="text-h5">
                  {{ currentUser.name }}
                </v-card-text>
              </v-col>
              <v-col cols="3" align="center">
                <v-btn color="info" class="my-auto" outlined small disabled>
                  Edit
                </v-btn>
              </v-col>
            </v-row>
          </v-container>
          <v-tabs
            v-model="tab"
            background-color="blue darken-4"
            right
            dark
            grow
            icons-and-text
          >
            <v-tabs-slider></v-tabs-slider>

            <v-tab href="#rooms">
              Rooms
              <v-icon>mdi-message-video</v-icon>
            </v-tab>

            <v-tab href="#friends">
              Friend List
              <v-icon>mdi-account-group</v-icon>
            </v-tab>

            <v-tab href="#followers">
              Notice
              <v-icon>mdi-bell-ring</v-icon>
            </v-tab>
          </v-tabs>
          <v-tabs-items
            v-model="tab"
          >
            <v-tab-item
              value="rooms"
            >
              <v-card flat>
                <v-card-text>
                  <v-list v-if="ownRooms.length > 0">
                    <template
                      v-for="(ownRoom, index) in ownRooms"
                    >
                      <v-subheader
                        v-if="index === 0"
                        :key="`ownRoom-header-${ownRoom.id}`"
                        v-text="'Host'"
                      />
                      <v-divider
                        v-else
                        :key="`ownRoom-divider-${ownRoom.id}`"
                        inset
                      />
                      <v-list-item
                        :key="`ownRoom-${ownRoom.id}`"
                      >
                        <v-list-item-content>
                          <v-list-item-title v-html="index + 1" />
                        </v-list-item-content>
                        <v-list-item-content>
                          <v-list-item-title v-text="shortUuid(ownRoom.uuid)" />
                        </v-list-item-content>
                        <v-list-item-icon
                          v-if="ownRoom.is_private"
                        >
                          <v-icon>mdi-lock</v-icon>
                        </v-list-item-icon>
                        <v-list-group
                          prepend-icon="mdi-account-circle"
                        >
                          <template v-slot:activator>
                            <v-list-item-title>
                              Members
                              <v-icon
                                v-if="ownRoom.users"
                                class="pl-5"
                              >
                                {{ iconMemberNum(ownRoom.users.length) }}
                              </v-icon>
                            </v-list-item-title>
                          </template>
                          <v-list-item
                            v-for="user in ownRoom.users"
                            :key="user.id"
                          >
                            <v-list-item-title v-text="user.name" />
                          </v-list-item>
                        </v-list-group>
                        <v-list-item-action>
                          <v-btn
                            color="green"
                            @click.prevent="enterRoom(ownRoom.uuid)"
                            small
                          >
                            enter
                          </v-btn>
                        </v-list-item-action>
                        <v-list-item-action>
                          <v-btn
                            color="red"
                            @click.prevent="deleteRoom(ownRoom.id)"
                            small
                            outlined
                          >
                            close
                          </v-btn>
                        </v-list-item-action>
                      </v-list-item>
                    </template>
                  </v-list>
                  <v-list v-if="rooms.length > 0">
                    <template
                      v-for="(room, index) in rooms"
                    >
                      <v-subheader
                        v-if="index === 0"
                        :key="`room-header-${room.id}`"
                        v-text="'Guest'"
                      />
                      <v-divider
                        v-else
                        :key="`room-divider-${room.id}`"
                        inset
                      />
                      <v-list-item
                        :key="`room-${room.id}`"
                      >
                        <v-list-item-content>
                          <v-list-item-title v-html="index + 1" />
                        </v-list-item-content>
                        <v-list-item-content>
                          <v-list-item-title v-text="shortUuid(room.uuid)" />
                        </v-list-item-content>
                        <v-list-item-icon
                          v-if="room.is_private"
                        >
                          <v-icon>mdi-lock</v-icon>
                        </v-list-item-icon>
                        <v-list-group
                          prepend-icon="mdi-account-circle"
                        >
                          <template v-slot:activator>
                            <v-list-item-title>
                              Members
                              <v-icon
                                v-if="room.users"
                                class="pl-5"
                              >
                                {{ iconMemberNum(room.users.length + 1) }}
                              </v-icon>
                            </v-list-item-title>
                          </template>
                          <v-list-item>
                            <v-list-item-title v-text="room.owner.name"/>
                            <v-list-item-subtitle v-text="'HOST'"/>
                          </v-list-item>
                          <v-list-item
                            v-for="user in room.users"
                            :key="user.id"
                          >
                            <v-list-item-title v-text="user.name" />
                          </v-list-item>
                        </v-list-group>
                        <v-list-item-action>
                          <v-btn
                            color="green"
                            @click.prevent="enterRoom(room.uuid)"
                            small
                          >
                            enter
                          </v-btn>
                        </v-list-item-action>
                        <v-list-item-action>
                          <v-btn
                            color="red"
                            @click.prevent="leave(room.id)"
                            small
                            outlined
                          >
                            leave
                          </v-btn>
                        </v-list-item-action>
                      </v-list-item>
                    </template>
                  </v-list>
                </v-card-text>
              </v-card>
            </v-tab-item>
            <v-tab-item
              value="friends"
            >
              <v-card flat>
                <v-list v-if="friends.length > 0">
                  <template
                    v-for="(friend, index) in friends"
                  >
                    <v-divider
                      v-if="index > 0"
                      :key="`friend-divider-${friend.id}`"
                      inset
                    />
                    <v-list-item
                      :key="`friend${friend.id}`"
                    >
                      <v-list-item-avatar>
                        <IconUser
                          :id="friend.id"
                          :name="friend.name"
                        />
                      </v-list-item-avatar>
                      <v-list-item-content>
                        <v-list-item-title v-html="friend.name" />
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn
                          color="red"
                          @click.prevent="unfollow(friend.id)"
                          small
                          outlined
                        >
                          remove
                        </v-btn>
                      </v-list-item-action>
                    </v-list-item>
                  </template>
                </v-list>
              </v-card>
            </v-tab-item>
            <v-tab-item
              value="followers"
            >
              <v-card flat>
                <v-list v-if="followers.length > 0">
                  <template
                    v-for="(follower, index) in followers"
                  >
                    <v-subheader
                      v-if="index === 0"
                      :key="`follower-header-${follower.id}`"
                      v-text="'Following you'"
                    />
                    <v-divider
                      v-else
                      :key="`follower-divider-${follower.id}`"
                      inset
                    />
                    <v-list-item
                      :key="`follower${follower.id}`"
                    >
                      <v-list-item-avatar>
                        <IconUser
                          :id="follower.id"
                          :name="follower.name"
                        />
                      </v-list-item-avatar>
                      <v-list-item-content>
                        <v-list-item-title v-html="follower.name" />
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn
                          color="blue"
                          @click.prevent="follow(follower.id)"
                          small
                        >
                          Accepts
                        </v-btn>
                      </v-list-item-action>
                    </v-list-item>
                  </template>
                </v-list>
              </v-card>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import IconUser from '@/components/IconUser'
import { fetchMypageInfo } from '@/services/mypage'
import { createFriendShip, deleteFriendShip } from '@/services/friendships'
import { deleteRoom } from '@/services/rooms'
import { deleteSubscription } from '@/services/subscriptions'

export default {
  name: 'MyPage',
  components: {
    IconUser
  },
  data () {
    return {
      tab: {},
      currentUser: null,
      friends: [],
      ownRooms: [],
      rooms: [],
      followers: []
    }
  },
  created () {
    this.setMypageInfo()
  },
  computed: {
    shortUuid () {
      return (str) => str.slice(0, 6)
    },
    iconMemberNum () {
      return (length) => `mdi-numeric-${length}-circle-outline`
    }
  },
  methods: {
    setMypageInfo () {
      fetchMypageInfo()
        .then((res) => {
          this.currentUser = res.data.current_user
          this.ownRooms = res.data.own_rooms
          this.rooms = res.data.rooms
          this.friends = res.data.friends
          this.followers = res.data.followers
        })
    },
    follow (id) {
      createFriendShip(id)
        .then(() => {
          this.followers = this.followers.filter(follower => follower.id !== id)
        })
    },
    unfollow (id) {
      deleteFriendShip(id)
        .then(() => {
          this.friends = this.friends.filter(friend => friend.id !== id)
        })
    },
    enterRoom (uuid) {
      this.$router.push(`/room/${uuid}`)
    },
    deleteRoom (id) {
      deleteRoom(id)
        .then(() => {
          this.ownRooms = this.ownRooms.filter(room => room.id !== id)
        })
    },
    leave (roomId) {
      deleteSubscription(roomId)
        .then(() => {
          this.rooms = this.rooms.filter(room => room.id !== roomId)
        })
    }
  }
}
</script>
