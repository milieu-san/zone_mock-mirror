<template>
  <v-container>
    <v-row align="center">
      <v-col
        md="6"
        class="mx-auto"
      >
        <v-text-field
          outlined
          rounded
          placeholder="type user name..."
          prepend-inner-icon="mdi-magnify"
          append-icon="mdi-close-circle-outline"
          v-model="query"
          @click:prepend-inner="searchUsers()"
          @click:append="resetUsers()"
          v-on:keyup.enter="searchUsers()"
        />
      </v-col>
    </v-row>
    <v-row
      v-if="users.length > 0"
      align="center"
    >
      <v-col
        v-for="user in users"
        :key="user.id"
        xs="12"
        sm="12"
        md="6"
        lg="4"
        align="center"
      >
        <v-card
          class="mx-auto justify-center"
          min-height="120"
        >
          <div
            class="text-overline text-left pl-5"
            style="height: 32px;"
          >
            {{ friendship(user.id) }}
          </div>
          <v-card-title>
            <IconUser
              :id="user.id"
              :name="user.name"
            />
            <span class="ml-5">
              {{ user.name }}
            </span>
            <v-spacer></v-spacer>
            <v-btn
              fab
              dark
              small
              :color="isFollowing(user.id) ? 'pink' : 'gray'"
              @click.prevent="switchFollowing(user.id)"
            >
              <v-icon dark>
                mdi-heart
              </v-icon>
            </v-btn>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <v-row align="center">
      <v-col
        cols="12"
        align="center"
      >
        <v-btn
          rounded
          v-if="!isLastPage"
          :disabled="isRequesting"
          @click.prevent="getMore()"
        >
          more
        </v-btn>
      </v-col>
    </v-row>
    <v-progress-circular
      v-if="isRequesting"
      indeterminate
    />
  </v-container>
</template>

<script>
import IconUser from '@/components/IconUser'
import { getUsers } from '@/services/users'
import { createFriendShip, deleteFriendShip } from '@/services/friendships'

export default {
  name: 'Users',
  components: {
    IconUser
  },
  data () {
    return {
      isRequesting: false,
      query: null,
      page: 1,
      totalPage: 0,
      users: [],
      followingIds: [],
      followerIds: []
    }
  },
  created () {
    this.fetchUsers()
  },
  computed: {
    isFollowing () {
      return (id) => this.followingIds.includes(id)
    },
    isFollowed () {
      return (id) => this.followerIds.includes(id)
    },
    isFriend () {
      return (id) => this.isFollowing(id) && this.isFollowed(id)
    },
    friendship () {
      return (id) => {
        if (this.isFriend(id)) {
          return 'friend'
        } else if (this.isFollowing(id)) {
          return 'following'
        } else if (this.isFollowed(id)) {
          return 'followed'
        } else {
          return null
        }
      }
    },
    isLastPage () {
      return this.page >= this.totalPage
    }
  },
  methods: {
    fetchUsers (isAdditional) {
      this.isRequesting = true

      getUsers({
        query: this.query,
        page: this.page
      })
        .then((res) => {
          if (isAdditional) {
            this.users = this.users.concat(res.data.users)
          } else {
            this.users = res.data.users
          }
          this.totalPage = res.data.total_page
          this.followingIds = res.data.following_ids
          this.followerIds = res.data.follower_ids
        })
        .finally(() => {
          this.isRequesting = false
        })
    },
    getMore () {
      this.page++
      this.fetchUsers(true)
    },
    resetUsers () {
      this.query = null
      this.page = 1
      this.fetchUsers()
    },
    searchUsers () {
      this.page = 1
      this.fetchUsers()
    },
    follow (id) {
      createFriendShip(id)
        .then(() => {
          this.followingIds.push(id)
          this.followingIds.splice()
        })
    },
    unfollow (id) {
      deleteFriendShip(id)
        .then(() => {
          this.followingIds = this.followingIds.filter(followingId => followingId !== id)
        })
    },
    switchFollowing (id) {
      if (this.isFollowing(id)) {
        this.unfollow(id)
      } else {
        this.follow(id)
      }
    }
  }
}
</script>
