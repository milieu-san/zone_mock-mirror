<template>
  <v-container fill-height>
    <v-row>
      <v-col cols="12" class="align-center">
        <v-card
          class="mx-auto"
          max-width="960"
        >
          <v-card-title>
            Select Condition
          </v-card-title>
          <v-container>
            <v-row>
              <v-col cols="6">
                <v-select
                  v-model="maxPeople"
                  prepend-icon="mdi-account-multiple"
                  :items="peopleRange"
                  label="max people"
                  disabled
                />
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="6">
                <v-menu
                  ref="timeStart"
                  v-model="startTimeMenu"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  :return-value.sync="timeStart"
                  transition="scale-transition"
                  offset-y
                  max-width="290px"
                  min-width="290px"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="timeStart"
                      label="start"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                      disabled
                    />
                  </template>
                  <v-time-picker
                    v-if="startTimeMenu"
                    v-model="timeStart"
                    :max="timeEnd"
                    full-width
                    @click:minute="$refs.timeStart.save(timeStart)"
                  ></v-time-picker>
                </v-menu>
              </v-col>
              <v-col cols="6">
                <v-menu
                  ref="timeEnd"
                  v-model="endTimeMenu"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  :return-value.sync="timeEnd"
                  transition="scale-transition"
                  offset-y
                  max-width="290px"
                  min-width="290px"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="timeEnd"
                      label="end"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                      disabled
                    />
                  </template>
                  <v-time-picker
                    v-if="endTimeMenu"
                    v-model="timeEnd"
                    :min="timeStart"
                    full-width
                    @click:minute="$refs.timeEnd.save(timeEnd)"
                  />
                </v-menu>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="4" class="align-center">
                <v-checkbox
                  v-model="video"
                  label="video"
                  disabled
                />
              </v-col>
              <v-col cols="4" class="align-center">
                <v-checkbox
                  v-model="sound"
                  label="sound"
                  disabled
                />
              </v-col>
              <v-col cols="4" class="align-center">
                <v-checkbox
                  v-model="chat"
                  label="chat"
                  disabled
                />
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12">
                <v-checkbox
                  v-model="privateRoom"
                  prepend-icon="mdi-lock"
                  label="private"
                />
              </v-col>
            </v-row>
            <v-row v-if="privateRoom">
              <v-col
                cols="12"
                class="pt-0"
              >
                <v-container class="py-0">
                  <v-row
                    align="center"
                    justify="start"
                  >
                    <v-col
                      v-for="(friend, i) in selectedFriends"
                      :key="friend.id"
                      class="shrink"
                    >
                      <v-chip
                        close
                        @click:close="selectedFriends.splice(i, 1)"
                      >
                        <v-icon
                          left
                        >
                          mdi-account
                        </v-icon>
                        {{ friend.name }}
                      </v-chip>
                    </v-col>

                    <v-col
                      cols="12"
                      class="pt-0"
                    >
                      <v-text-field
                        v-model="searchParams"
                        full-width
                        hide-details
                        label="Search friends"
                        single-line
                        class="pt-0 mt-0"
                      />
                    </v-col>
                  </v-row>
                </v-container>
                <v-divider />
                <v-list v-if="selectedFriends.length < maxPeople">
                  <template
                    v-for="friend in filteredFriends"
                  >
                    <v-list-item
                      :key="friend.id"
                      v-if="!selectedFriends.includes(friend)"
                      @click="selectedFriends.push(friend)"
                    >
                      <v-list-item-avatar>
                        <v-icon>
                          mdi-account
                        </v-icon>
                      </v-list-item-avatar>
                      <v-list-item-title v-text="friend.name" />
                    </v-list-item>
                  </template>
                </v-list>
              </v-col>
            </v-row>
            <v-divider class="pb-4" />
            <v-btn
              color="info"
              class="mr-4"
              @click.prevent="createRoom"
            >
              Create Room
            </v-btn>
          </v-container>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import router from '@/router'
import { notice } from '@/plugins/notice'
import { createRoom } from '@/services/rooms'
import { getFriends } from '@/services/users'

export default {
  name: 'RoomNew',
  data () {
    return {
      peopleRange: [...Array(16)].map((_, i) => i + 1),
      startTimeMenu: false,
      endTimeMenu: false,
      maxPeople: 1,
      privateRoom: false,
      timeStart: null,
      timeEnd: null,
      video: true,
      sound: true,
      chat: true,
      friends: [],
      selectedFriends: [],
      searchParams: ''
    }
  },
  created () {
    this.fetchFriends()
  },
  computed: {
    selectedFriendIds () {
      return this.selectedFriends.map((friend) => { return friend.id })
    },
    filteredFriends () {
      const search = this.searchParams.toLowerCase()

      if (!search) return this.friends

      return this.friends.filter(friend => {
        const name = friend.name.toLowerCase()

        return name.indexOf(search) > -1
      })
    }
  },
  methods: {
    createRoom () {
      const params = {
        capacity: this.maxPeople,
        start_at: this.timeStart,
        finish_at: this.timeEnd,
        is_accepted_camera: this.video,
        is_accepted_audio: this.sound,
        is_accepted_chat: this.chat,
        is_private: this.privateRoom,
        user_ids: this.selectedFriendIds
      }
      createRoom(params)
        .then(() => {
          notice('success', 'Succeeded to create room')
          router.push('/mypage')
        })
        .catch(() => {
          notice('warning', 'Failed to create room. Try again.')
        })
    },
    fetchFriends () {
      getFriends()
        .then(res => {
          this.friends = res.data.friends
        })
    }
  }
}
</script>

<style scoped>
.v-list {
  height: 300px;
  overflow-y: auto;
}
</style>
