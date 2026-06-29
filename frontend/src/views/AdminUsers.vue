<template>
  <div class="admin-users-page">
    <!-- 顶部导航 -->
    <header class="header">
      <div class="header-left">
        <h1>👥 用户管理</h1>
        <span class="badge">管理员</span>
      </div>
      <div class="header-right">
        <el-button @click="router.push('/tasks')">返回任务</el-button>
        <el-dropdown @command="handleCommand">
          <span class="user-dropdown">
            <el-avatar :size="32" :src="avatarUrl">
              {{ userStore.user?.username?.charAt(0)?.toUpperCase() }}
            </el-avatar>
            <span class="username">{{ userStore.user?.username }}</span>
            <el-icon><ArrowDown /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </header>

    <!-- 用户列表 -->
    <div class="user-list">
      <el-table :data="userList" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" min-width="150" />
        <el-table-column prop="role" label="角色" width="120">
          <template #default="{ row }">
            <el-tag :type="row.role === 1 ? 'warning' : 'info'" size="small">
              {{ row.role === 1 ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="120">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '正常' : '已禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280" fixed="right">
          <template #default="{ row }">
            <!-- 不能操作自己 -->
            <template v-if="row.id !== userStore.user?.id">
              <el-button
                  size="small"
                  :type="row.status === 1 ? 'warning' : 'success'"
                  @click="toggleStatus(row)"
              >
                {{ row.status === 1 ? '禁用' : '启用' }}
              </el-button>
              <el-button size="small" type="danger" plain @click="resetPassword(row)">
                重置密码
              </el-button>
            </template>
            <span v-else style="color: #ccc;">当前账号</span>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
            v-model:current-page="page"
            v-model:page-size="size"
            :total="total"
            :page-sizes="[5, 10, 20, 50]"
            layout="total, sizes, prev, pager, next"
            @size-change="loadUsers"
            @current-change="loadUsers"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowDown } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'
import request from '@/utils/request'

const router = useRouter()
const userStore = useUserStore()

// 检查是否为管理员
if (userStore.user?.role !== 1) {
  ElMessage.error('需要管理员权限')
  router.push('/tasks')
}

const avatarUrl = computed(() => {
  const user = localStorage.getItem('user')
  if (user) {
    const parsed = JSON.parse(user)
    if (parsed.avatarUrl) {
      if (parsed.avatarUrl.startsWith('http')) {
        return parsed.avatarUrl
      }
      return `http://localhost:8080${parsed.avatarUrl}`
    }
  }
  return ''
})

const userList = ref([])
const loading = ref(false)
const total = ref(0)
const page = ref(1)
const size = ref(10)

const loadUsers = async () => {
  loading.value = true
  try {
    const res = await request.get('/api/admin/users', {
      params: { page: page.value, size: size.value }
    })
    if (res.code === 200) {
      userList.value = res.data.list || []
      total.value = res.data.total || 0
    }
  } catch (error) {
    ElMessage.error('加载用户列表失败')
  } finally {
    loading.value = false
  }
}

const toggleStatus = async (row) => {
  const action = row.status === 1 ? '禁用' : '启用'
  try {
    await ElMessageBox.confirm(`确定要${action}用户「${row.username}」吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const newStatus = row.status === 1 ? 0 : 1
    const res = await request.put(`/api/admin/users/${row.id}/status`, null, {
      params: { status: newStatus }
    })
    if (res.code === 200) {
      ElMessage.success(`用户已${action}`)
      loadUsers()
    } else {
      ElMessage.error(res.message || '操作失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('操作失败')
    }
  }
}

const resetPassword = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要重置用户「${row.username}」的密码为 123456 吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await request.put(`/api/admin/users/${row.id}/reset-password`)
    if (res.code === 200) {
      ElMessage.success('密码已重置为 123456')
    } else {
      ElMessage.error(res.message || '操作失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('操作失败')
    }
  }
}

const handleCommand = (command) => {
  if (command === 'profile') {
    router.push('/profile')
  } else if (command === 'logout') {
    userStore.clearUser()
    ElMessage.success('已退出')
    router.push('/login')
  }
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.admin-users-page {
  min-height: 100vh;
  background: #f5f7fa;
  padding: 20px 40px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
  border-bottom: 1px solid #e8ecf1;
  margin-bottom: 24px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-left h1 {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a2e;
}

.badge {
  font-size: 12px;
  background: #F56C6C;
  color: #fff;
  padding: 2px 12px;
  border-radius: 12px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 12px 4px 4px;
  border-radius: 20px;
  transition: background 0.2s;
}

.user-dropdown:hover {
  background: #e8ecf1;
}

.username {
  font-size: 14px;
  color: #333;
}

.user-list {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.pagination {
  display: flex;
  justify-content: flex-end;
  padding: 16px 0 0;
}
</style>