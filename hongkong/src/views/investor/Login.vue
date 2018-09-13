<template lang="pug">
  .login
    .container.d-flex.align-items-center
      .row.justify-content-md-center
        .col-1 E-MAIL
        .col-1: input(v-model='mail' type='email')
      .row.justify-content-md-center
        .col-1  Password
        .col-1: input(v-model='password' type='password')
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

@Component({
  components: {},
})
export default class Home extends Vue {
  private mail: string = '';
  private password: string = '';
}
</script>

<style>
  @import '../../../node_modules/bootstrap/dist/css/bootstrap.min.css';
</style>