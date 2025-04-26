<template>
    <div id="app">
        <button @click="count++">
            Count is: {{ count+100 }}
        </button>
    </div>
</template>

<script>
import { ref } from 'vue';

export default {
    setup() {
        return {
            count: ref(0),
        };
    },
};
</script>
